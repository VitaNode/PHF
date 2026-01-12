/// # ReviewEditPage Component
///
/// ## Description
/// 专门用于校对刚识别完成的 OCR 结果。支持多图平滑切换。
///
/// ## Features (Phase 4)
/// - **Sticky Magnifier**: 编辑模式下，预览浮层固定在顶部，不随内容滚动。
/// - **Immersive Edit**: 编辑模式下自动隐藏文档原图，提供全屏编辑空间。
/// - **Precise Targeting**: 点击不同字段，预览区精准对焦至原图相应位置。
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:phf/presentation/widgets/focus_zoom_overlay.dart';
import 'package:phf/logic/services/slm/layout_parser.dart';
import 'package:phf/data/models/slm/slm_data_block.dart';
import '../../../data/models/record.dart';
import '../../../data/models/image.dart';
import '../../../data/models/ocr_result.dart';
import '../../../logic/providers/core_providers.dart';
import '../../../logic/providers/review_list_provider.dart';
import '../../../logic/providers/timeline_provider.dart';
import '../../theme/app_theme.dart';

class ReviewEditPage extends ConsumerStatefulWidget {
  final MedicalRecord record;

  const ReviewEditPage({super.key, required this.record});

  @override
  ConsumerState<ReviewEditPage> createState() => _ReviewEditPageState();
}

class _ReviewEditPageState extends ConsumerState<ReviewEditPage> {
  late TextEditingController _hospitalController;
  final FocusNode _hospitalFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  DateTime? _visitDate;
  int _currentImageIndex = 0;

  // Structured data blocks
  List<SLMDataBlock> _currentBlocks = [];
  final List<TextEditingController> _blockControllers = [];
  final List<FocusNode> _blockFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _hospitalController = TextEditingController();
    _hospitalFocus.addListener(() => setState(() {}));
    _dateFocus.addListener(() => setState(() {}));
    _updateControllersForIndex(0);
  }

  @override
  void dispose() {
    _hospitalController.dispose();
    _hospitalFocus.dispose();
    _dateFocus.dispose();
    _disposeBlockResources();
    super.dispose();
  }

  void _disposeBlockResources() {
    for (final c in _blockControllers) {
      c.dispose();
    }
    for (final f in _blockFocusNodes) {
      f.dispose();
    }
    _blockControllers.clear();
    _blockFocusNodes.clear();
  }

  void _updateControllersForIndex(int index) {
    final images = widget.record.images;
    if (index < 0 || index >= images.length) return;

    final img = images[index];
    _hospitalController.text =
        img.hospitalName ?? widget.record.hospitalName ?? '';
    _visitDate = img.visitDate ?? widget.record.notedAt;

    _disposeBlockResources();
    OcrResult? ocr;
    if (img.ocrRawJson != null) {
      try {
        ocr = OcrResult.fromJson(
          jsonDecode(img.ocrRawJson!) as Map<String, dynamic>,
        );
      } catch (_) {}
    }

    if (ocr != null) {
      _currentBlocks = LayoutParser().parse(ocr);
      for (final block in _currentBlocks) {
        final controller = TextEditingController(text: block.rawText);
        final focusNode = FocusNode();
        focusNode.addListener(() => setState(() {}));
        _blockControllers.add(controller);
        _blockFocusNodes.add(focusNode);
      }
    } else {
      _currentBlocks = [];
    }
  }

  Future<void> _approve() async {
    try {
      final recordRepo = ref.read(recordRepositoryProvider);
      final imageRepo = ref.read(imageRepositoryProvider);
      final reviewNotifier = ref.read(reviewListControllerProvider.notifier);

      if (_blockControllers.isNotEmpty) {
        final newFullText = _blockControllers.map((c) => c.text).join('\n');
        await imageRepo.updateOCRData(
          widget.record.images[_currentImageIndex].id,
          newFullText,
        );
      }

      await recordRepo.updateRecordMetadata(
        widget.record.id,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );

      await reviewNotifier.approveRecord(widget.record.id);
      ref.invalidate(timelineControllerProvider);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.review_approve_failed(e.toString()))),
        );
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(
        l10n.review_edit_title,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        TextButton(
          onPressed: _approve,
          child: Text(
            l10n.review_edit_confirm,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildMagnifier(MedicalImage currentImage) {
    List<double>? rect;
    if (_hospitalFocus.hasFocus) {
      rect = LayoutParser().findFieldCoordinates(_currentBlocks, 'hospital');
    } else if (_dateFocus.hasFocus) {
      rect = LayoutParser().findFieldCoordinates(_currentBlocks, 'date');
    } else {
      final idx = _blockFocusNodes.indexWhere((f) => f.hasFocus);
      if (idx != -1) rect = _currentBlocks[idx].boundingBox;
    }

    if (rect == null) return const SizedBox.shrink();

    return Container(
      height: 160,
      width: double.infinity,
      color: Colors.black,
      child: FocusZoomOverlay(
        imagePath: currentImage.filePath,
        encryptionKey: currentImage.encryptionKey,
        normalizedRect: rect,
      ),
    );
  }

  Widget _buildImageNav(int total) {
    if (total <= 1) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.black.withValues(alpha: 0.05),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentImageIndex > 0
                ? () {
                    setState(() {
                      _currentImageIndex--;
                      _updateControllersForIndex(_currentImageIndex);
                    });
                  }
                : null,
          ),
          Text(
            l10n.review_edit_page_indicator(_currentImageIndex + 1, total),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentImageIndex < total - 1
                ? () {
                    setState(() {
                      _currentImageIndex++;
                      _updateControllersForIndex(_currentImageIndex);
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(bool isLow, Color? warnColor) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () async {
        setState(() {
          _dateFocus.requestFocus();
        });
        final date = await showDatePicker(
          context: context,
          initialDate: _visitDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) setState(() => _visitDate = date);
      },
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
            text: _visitDate != null
                ? DateFormat('yyyy-MM-dd').format(_visitDate!)
                : '',
          ),
          focusNode: _dateFocus,
          decoration: InputDecoration(
            labelText: l10n.review_edit_date_label,
            prefixIcon: const Icon(Icons.calendar_today),
            border: const OutlineInputBorder(),
            filled: isLow,
            fillColor: isLow ? warnColor : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.record.images;
    if (images.isEmpty) return const SizedBox();
    final currentImage = images[_currentImageIndex];
    final l10n = AppLocalizations.of(context)!;
    final isLowConfidence =
        currentImage.ocrConfidence != null && currentImage.ocrConfidence! < 0.8;
    final warningColor = Colors.orange.shade50;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildMagnifier(currentImage),
          _buildImageNav(images.length),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.review_edit_basic_info,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _hospitalController,
                    focusNode: _hospitalFocus,
                    onTap: () => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.review_edit_hospital_label,
                      prefixIcon: const Icon(Icons.local_hospital_outlined),
                      border: const OutlineInputBorder(),
                      filled: isLowConfidence,
                      fillColor: isLowConfidence ? warningColor : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDatePicker(isLowConfidence, warningColor),

                  const SizedBox(height: 32),
                  if (_blockControllers.isNotEmpty) ...[
                    Text(
                      l10n.review_edit_ocr_section,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.review_edit_ocr_hint,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textHint,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _blockControllers.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final block = _currentBlocks[index];
                        final isBlockLow = block.confidence < 0.8;
                        return TextField(
                          controller: _blockControllers[index],
                          focusNode: _blockFocusNodes[index],
                          onTap: () => setState(() {}),
                          maxLines: null,
                          style: AppTheme.monoStyle.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            filled: isBlockLow,
                            fillColor: isBlockLow
                                ? warningColor
                                : Colors.grey.shade50,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            isDense: true,
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
