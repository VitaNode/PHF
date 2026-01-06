import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/record.dart';
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
  DateTime? _visitDate;
  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _hospitalController = TextEditingController();
    _updateControllersForIndex(0);
  }

  @override
  void dispose() {
    _hospitalController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final images = widget.record.images;
    if (images.isEmpty) return const SizedBox(); // Should not happen

    final currentImage = images[_currentImageIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('校对信息', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: _approve,
            child: const Text(
              '确认归档',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top: Image Viewer with OCR Highlights
          Expanded(
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
                          '图片 ${_currentImageIndex + 1} / ${images.length} (请核对每页信息)',
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
          ),

          // Bottom: Edit Form
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '基本信息 (可点击修改)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _hospitalController,
                      decoration: const InputDecoration(
                        labelText: '医院/机构名称',
                        prefixIcon: Icon(Icons.local_hospital_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
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
                          decoration: const InputDecoration(
                            labelText: '就诊日期',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (currentImage.ocrConfidence != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryTeal.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.primaryTeal.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: AppTheme.primaryTeal,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'OCR 置信度: ${(currentImage.ocrConfidence! * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: AppTheme.primaryTeal,
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
          ),
        ],
      ),
    );
  }
}
