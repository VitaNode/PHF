import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:phf/presentation/widgets/focus_zoom_overlay.dart';
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
    _pageController.dispose();
    super.dispose();
  }

  void _updateControllersForIndex(int index) {
    final images = widget.record.images;
    if (index < 0 || index >= images.length) return;

    final img = images[index];
    // 优先显示图片特有的信息，如果没有则回退到 Record 级别
    _hospitalController.text =
        img.hospitalName ?? widget.record.hospitalName ?? '';
    _visitDate = img.visitDate ?? widget.record.notedAt;
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
      final reviewNotifier = ref.read(reviewListControllerProvider.notifier);

      // 1. Save changes if any
      await recordRepo.updateRecordMetadata(
        widget.record.id,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );

      // 2. Approve status
      await reviewNotifier.approveRecord(widget.record.id);

      // 3. Refresh timeline
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

  Widget _buildImageViewer(List<MedicalImage> images) {
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
                    builder:
                        (
                          BuildContext context,
                          ImageProvider<Object> imageProvider,
                        ) {
                          return OCRHighlightView(
                            imageProvider: imageProvider,
                            ocrResult: currentOcr,
                            actualImageSize:
                                (img.width != null && img.height != null)
                                ? Size(
                                    img.width!.toDouble(),
                                    img.height!.toDouble(),
                                  )
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.review_edit_page_indicator(
                      _currentImageIndex + 1,
                      images.length,
                    ),
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
    if (!_hospitalFocus.hasFocus && !_dateFocus.hasFocus) {
      return const SizedBox(height: 8);
    }

    // Heuristic: Try to find coordinates for current focused field
    // For now, if focused, we default to the top area where hospital/date usually resides.
    // In Phase 5, we can use SmartExtractor to get exact bounding boxes.
    final rect = [0.0, 0.0, 1.0, 0.25]; // Top 25% of image

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FocusZoomOverlay(
        imagePath: currentImage.filePath,
        encryptionKey: currentImage.encryptionKey,
        normalizedRect: rect,
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
              GestureDetector(
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
                      border: const OutlineInputBorder(),
                      filled: isLowConfidence,
                      fillColor: isLowConfidence ? warningColor : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (currentImage.ocrConfidence != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isLowConfidence
                        ? Colors.orange.shade50
                        : AppTheme.primaryTeal.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isLowConfidence
                          ? Colors.orange.shade200
                          : AppTheme.primaryTeal.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isLowConfidence
                            ? Icons.warning_amber
                            : Icons.auto_awesome,
                        size: 16,
                        color: isLowConfidence
                            ? Colors.orange
                            : AppTheme.primaryTeal,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${l10n.review_edit_confidence}: ${(currentImage.ocrConfidence! * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: isLowConfidence
                              ? Colors.orange
                              : AppTheme.primaryTeal,
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
