/// # ReviewEditPage Component
///
/// ## Description
/// 专门用于校对刚识别完成的 OCR 结果。
///
/// ## Features (Phase 4)
/// - **Enhanced Edit**: 点击编辑字段时显示 FocusZoomOverlay 放大预览。
/// - **i18n**: 全面支持多语言动态切换。
/// - **Confidence Highlighting**: 置信度低于 0.8 的字段应用橙色高亮。
/// - **Verification Status**: 归档后自动标记记录为已校验 (is_verified).
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
import '../../widgets/secure_image.dart';
import 'widgets/ocr_highlight_view.dart';

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
  late PageController _pageController;

  // New: Structured data blocks
  List<SLMDataBlock> _currentBlocks = [];
  final List<TextEditingController> _blockControllers = [];
  final List<FocusNode> _blockFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    _pageController.dispose();
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
    _hospitalController.text = img.hospitalName ?? widget.record.hospitalName ?? '';
    _visitDate = img.visitDate ?? widget.record.notedAt;

    // Parse blocks for structured editing
    _disposeBlockResources();
    OcrResult? ocr;
    if (img.ocrRawJson != null) {
      try {
        ocr = OcrResult.fromJson(jsonDecode(img.ocrRawJson!) as Map<String, dynamic>);
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

  void _onImageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
      _updateControllersForIndex(index);
    });
  }

  Future<void> _approve() async {
    try {
      final recordRepo = ref.read(recordRepositoryProvider);
      final imageRepo = ref.read(imageRepositoryProvider);
      final reviewNotifier = ref.read(reviewListControllerProvider.notifier);

      // 1. Aggregated OCR text if edited
      if (_blockControllers.isNotEmpty) {
        final newFullText = _blockControllers.map((c) => c.text).join('\n');
        await imageRepo.updateOCRData(
          widget.record.images[_currentImageIndex].id,
          newFullText,
        );
      }

      // 2. Save changes and mark as verified (Automatic in Repository update)
      await recordRepo.updateRecordMetadata(
        widget.record.id,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );

      // 3. Approve status
      await reviewNotifier.approveRecord(widget.record.id);

      // 4. Refresh timeline
      ref.invalidate(timelineControllerProvider);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('归档失败: $e')));
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(l10n.review_edit_title, style: const TextStyle(color: Colors.black)),
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

  Widget _buildImageViewer(List<MedicalImage> images) {
    final l10n = AppLocalizations.of(context)!;
    return Expanded(
      flex: 3,
      child: Container(
        color: Colors.black87,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: _onImageChanged,
              itemBuilder: (context, index) {
                final img = images[index];
                OcrResult? currentOcr;
                if (img.ocrRawJson != null) {
                  try {
                    currentOcr = OcrResult.fromJson(
                      jsonDecode(img.ocrRawJson!) as Map<String, dynamic>,
                    );
                  } catch (_) {}
                }

                return Center(
                  child: SecureImage(
                    imagePath: img.filePath,
                    encryptionKey: img.encryptionKey,
                    fit: BoxFit.contain,
                    builder: (context, imageProvider) {
                      return OCRHighlightView(
                        imageProvider: imageProvider,
                        ocrResult: currentOcr,
                        actualImageSize: (img.width != null && img.height != null)
                            ? Size(img.width!.toDouble(), img.height!.toDouble())
                            : null,
                      );
                    },
                  ),
                );
              },
            ),
            // Navigation Arrows
            if (images.length > 1) ...[
              if (_currentImageIndex > 0)
                Positioned(
                  left: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                  ),
                ),
              if (_currentImageIndex < images.length - 1)
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
            // Page Indicator
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    l10n.review_edit_page_indicator(_currentImageIndex + 1, images.length),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomOverlay(MedicalImage currentImage) {
    final finalRect = (_hospitalFocus.hasFocus || _dateFocus.hasFocus)
        ? const [0.0, 0.0, 1.0, 0.25]
        : (() {
            final idx = _blockFocusNodes.indexWhere((f) => f.hasFocus);
            return idx != -1 ? _currentBlocks[idx].boundingBox : null;
          })();

    if (finalRect == null) return const SizedBox(height: 8);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FocusZoomOverlay(
        imagePath: currentImage.filePath,
        encryptionKey: currentImage.encryptionKey,
        normalizedRect: finalRect,
      ),
    );
  }

  Widget _buildEditForm(MedicalImage currentImage) {
    final l10n = AppLocalizations.of(context)!;
    final isLowConfidence =
        currentImage.ocrConfidence != null && currentImage.ocrConfidence! < 0.8;
    final warningColor = Colors.orange.shade50;

    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildZoomOverlay(currentImage),
              Text(
                l10n.review_edit_basic_info,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _hospitalController,
                focusNode: _hospitalFocus,
                decoration: InputDecoration(
                  labelText: l10n.review_edit_hospital_label,
                  prefixIcon: const Icon(Icons.local_hospital_outlined),
                  border: const OutlineInputBorder(),
                  filled: isLowConfidence,
                  fillColor: isLowConfidence ? warningColor : null,
                ),
              ),
              const SizedBox(height: 16),
              _buildDatePicker(currentImage, isLowConfidence, warningColor),
              const SizedBox(height: 32),
              
              // New: Structured Content Editor
              if (_blockControllers.isNotEmpty) ...[
                const Text(
                  '识别内容 (可点击逐行校对)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  '点击下方文字，上方将自动放大对应图片区域',
                  style: TextStyle(fontSize: 11, color: AppTheme.textHint),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _blockControllers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final block = _currentBlocks[index];
                    final isBlockLow = block.confidence < 0.8;
                    return TextField(
                      controller: _blockControllers[index],
                      focusNode: _blockFocusNodes[index],
                      maxLines: null,
                      style: AppTheme.monoStyle.copyWith(fontSize: 14),
                      decoration: InputDecoration(
                        filled: isBlockLow,
                        fillColor: isBlockLow ? warningColor : Colors.grey.shade50,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 16),
              if (currentImage.ocrConfidence != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isLowConfidence ? Colors.orange.shade50 : AppTheme.primaryTeal.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isLowConfidence ? Colors.orange.shade200 : AppTheme.primaryTeal.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isLowConfidence ? Icons.warning_amber : Icons.auto_awesome,
                        size: 16,
                        color: isLowConfidence ? Colors.orange : AppTheme.primaryTeal,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${l10n.review_edit_confidence}: ${(currentImage.ocrConfidence! * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: isLowConfidence ? Colors.orange : AppTheme.primaryTeal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(MedicalImage img, bool isLow, Color? warnColor) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () async {
        _dateFocus.requestFocus();
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
            text: _visitDate != null ? DateFormat('yyyy-MM-dd').format(_visitDate!) : '',
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

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildImageViewer(images),
          _buildEditForm(images[_currentImageIndex]),
        ],
      ),
    );
  }
}