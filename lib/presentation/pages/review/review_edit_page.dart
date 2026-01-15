/// # ReviewEditPage Component
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
  final bool isReviewMode;

  const ReviewEditPage({
    super.key,
    required this.record,
    this.isReviewMode = true,
  });

  @override
  ConsumerState<ReviewEditPage> createState() => _ReviewEditPageState();
}

class _ReviewEditPageState extends ConsumerState<ReviewEditPage> {
  late TextEditingController _hospitalController;
  final FocusNode _hospitalFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  DateTime? _visitDate;
  int _currentImageIndex = 0;

  List<SLMDataBlock> _currentBlocks = [];
  final List<TextEditingController> _blockControllers = [];
  final List<FocusNode> _blockFocusNodes = [];
  double? _currentConfidence;

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
      _currentConfidence = ocr.confidence;
      _currentBlocks = LayoutParser().parse(ocr);
      for (final block in _currentBlocks) {
        final controller = TextEditingController(text: block.rawText);
        final focusNode = FocusNode();
        focusNode.addListener(() => setState(() {}));
        _blockControllers.add(controller);
        _blockFocusNodes.add(focusNode);
      }
    } else {
      _currentConfidence = null;
      _currentBlocks = [];
    }
  }

  Future<void> _handleSave() async {
    try {
      final recordRepo = ref.read(recordRepositoryProvider);
      final imageRepo = ref.read(imageRepositoryProvider);
      final currentImage = widget.record.images[_currentImageIndex];

      if (_blockControllers.isNotEmpty) {
        final List<String> updatedTexts = _blockControllers
            .map((c) => c.text.trim())
            .toList();
        final newFullText = updatedTexts.where((t) => t.isNotEmpty).join('\n');

        // Reconstruct a clean OCR JSON structure based on the current visual order
        // This prevents "data disorganization" caused by sorting/clustering mismatches.
        String? updatedRawJson = currentImage.ocrRawJson;
        if (currentImage.ocrRawJson != null) {
          try {
            final oldOcr = OcrResult.fromJson(
              jsonDecode(currentImage.ocrRawJson!) as Map<String, dynamic>,
            );

            final List<OcrBlock> newBlocks = [];
            for (int i = 0; i < _currentBlocks.length; i++) {
              final block = _currentBlocks[i];
              final updatedText = _blockControllers[i].text.trim();
              if (updatedText.isEmpty) continue;

              // Create a flat but structurally correct block-line pair
              newBlocks.add(
                OcrBlock(
                  text: updatedText,
                  x: block.boundingBox[0],
                  y: block.boundingBox[1],
                  w: block.boundingBox[2],
                  h: block.boundingBox[3],
                  lines: [
                    OcrLine(
                      text: updatedText,
                      x: block.boundingBox[0],
                      y: block.boundingBox[1],
                      w: block.boundingBox[2],
                      h: block.boundingBox[3],
                      confidence: block.confidence,
                    ),
                  ],
                ),
              );
            }

            final updatedOcr = oldOcr.copyWith(
              text: newFullText,
              pages: [
                OcrPage(
                  pageNumber: 0,
                  blocks: newBlocks,
                  confidence: _currentConfidence ?? 0.0,
                ),
              ],
            );
            updatedRawJson = jsonEncode(updatedOcr.toJson());
          } catch (_) {
            // If reconstruction fails, we'll fall back to just saving text
          }
        }

        await imageRepo.updateOCRData(
          currentImage.id,
          newFullText,
          rawJson: updatedRawJson,
          confidence: _currentConfidence ?? 0.0,
        );
      }

      await imageRepo.updateImageMetadata(
        widget.record.images[_currentImageIndex].id,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );

      await recordRepo.updateRecordMetadata(
        widget.record.id,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );

      if (widget.isReviewMode) {
        final reviewNotifier = ref.read(reviewListControllerProvider.notifier);
        await reviewNotifier.approveRecord(widget.record.id);
      }
      ref.invalidate(timelineControllerProvider);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(
        widget.isReviewMode ? l10n.review_edit_title : l10n.detail_edit_title,
      ),
      actions: [
        TextButton(
          onPressed: _handleSave,
          child: Text(
            widget.isReviewMode ? l10n.review_edit_confirm : l10n.common_save,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.record.images.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(child: Text('无图片数据')),
      );
    }
    final currentImage = widget.record.images[_currentImageIndex];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildMagnifier(currentImage),
            _buildImageNav(widget.record.images.length),
            if (_currentConfidence != null)
              Container(
                width: double.infinity,
                color: _currentConfidence! < 0.6
                    ? AppTheme.warningOrange.withValues(alpha: 0.1)
                    : AppTheme.successGreen.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ),
                child: Text(
                  '${l10n.review_edit_confidence}: ${(_currentConfidence! * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: _currentConfidence! < 0.6
                        ? AppTheme.warningOrange
                        : AppTheme.successGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  _buildHospitalField(l10n),
                  const SizedBox(height: 16),
                  _buildDatePicker(l10n),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 8),
                  if (_currentBlocks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          '暂无 OCR 识别结果',
                          style: TextStyle(color: AppTheme.textHint),
                        ),
                      ),
                    )
                  else
                    ...List.generate(_currentBlocks.length, (i) {
                      if (i >= _blockControllers.length) {
                        return const SizedBox.shrink();
                      }
                      return _buildBlockField(i);
                    }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMagnifier(MedicalImage img) {
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
        imagePath: img.filePath,
        encryptionKey: img.encryptionKey,
        normalizedRect: rect,
      ),
    );
  }

  Widget _buildImageNav(int total) {
    if (total <= 1) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.black.withValues(alpha: 0.05),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentImageIndex > 0
                ? () => setState(() {
                    _currentImageIndex--;
                    _updateControllersForIndex(_currentImageIndex);
                  })
                : null,
          ),
          Text(l10n.review_edit_page_indicator(_currentImageIndex + 1, total)),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentImageIndex < total - 1
                ? () => setState(() {
                    _currentImageIndex++;
                    _updateControllersForIndex(_currentImageIndex);
                  })
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalField(AppLocalizations l10n) {
    return TextField(
      controller: _hospitalController,
      focusNode: _hospitalFocus,
      decoration: InputDecoration(
        labelText: l10n.review_edit_hospital_label,
        prefixIcon: const Icon(Icons.local_hospital),
      ),
    );
  }

  Widget _buildDatePicker(AppLocalizations l10n) {
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
            text: _visitDate != null
                ? DateFormat('yyyy-MM-dd').format(_visitDate!)
                : '',
          ),
          focusNode: _dateFocus,
          decoration: InputDecoration(
            labelText: l10n.review_edit_date_label,
            prefixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Widget _buildBlockField(int i) {
    final block = _currentBlocks[i];
    final isLowConfidence = block.confidence < 0.8;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: _blockControllers[i],
        focusNode: _blockFocusNodes[i],
        maxLines: null,
        decoration: InputDecoration(
          labelText: block.semanticLabel ?? 'Block ${i + 1}',
          alignLabelWithHint: true,
          filled: isLowConfidence,
          fillColor: isLowConfidence
              ? AppTheme.warningOrange.withValues(alpha: 0.1)
              : null,
          border: const OutlineInputBorder(),
          suffixText: '${(block.confidence * 100).toStringAsFixed(0)}%',
          suffixStyle: TextStyle(
            fontSize: 12,
            color: isLowConfidence ? AppTheme.warningOrange : AppTheme.textHint,
            fontWeight: isLowConfidence ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
