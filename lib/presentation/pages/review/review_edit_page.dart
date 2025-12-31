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

  @override
  void initState() {
    super.initState();
    _hospitalController = TextEditingController(text: widget.record.hospitalName);
    _visitDate = widget.record.notedAt;
  }

  @override
  void dispose() {
    _hospitalController.dispose();
    super.dispose();
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
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('归档失败: $e')));
       }
     }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.record.images;
    if (images.isEmpty) return const SizedBox(); // Should not happen
    
    final currentImage = images[_currentImageIndex];
    OCRResult? ocrResult;
    if (currentImage.ocrRawJson != null) {
      try {
        ocrResult = OCRResult.fromJson(jsonDecode(currentImage.ocrRawJson!) as Map<String, dynamic>);
      } catch (_) {}
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('校对信息', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: _approve,
            child: const Text('确认归档', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                   Center(
                     child: SecureImage(
                       imagePath: currentImage.filePath,
                       encryptionKey: currentImage.encryptionKey,
                       width: null, // Let layout handle constraint or pass specific
                       fit: BoxFit.contain,
                       builder: (BuildContext context, ImageProvider<Object> imageProvider) {
                         return OCRHighlightView(
                           imageProvider: imageProvider,
                           ocrResult: ocrResult,
                           actualImageSize: (currentImage.width != null && currentImage.height != null) 
                               ? Size(currentImage.width!.toDouble(), currentImage.height!.toDouble())
                               : null,
                         );
                       },
                     ),
                   ),
                   // Navigation Arrows
                   if (images.length > 1) ...[
                     if (_currentImageIndex > 0)
                       Positioned(
                         left: 8, top: 0, bottom: 0,
                         child: IconButton(
                           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                           onPressed: () => setState(() => _currentImageIndex--),
                         ),
                       ),
                     if (_currentImageIndex < images.length - 1)
                       Positioned(
                         right: 8, top: 0, bottom: 0,
                         child: IconButton(
                           icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                           onPressed: () => setState(() => _currentImageIndex++),
                         ),
                       ),
                   ],
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
                    const Text('基本信息 (可点击修改)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                            text: _visitDate != null ? DateFormat('yyyy-MM-dd').format(_visitDate!) : '',
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
                          border: Border.all(color: AppTheme.primaryTeal.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome, size: 16, color: AppTheme.primaryTeal),
                            const SizedBox(width: 8),
                            Text(
                              'OCR 置信度: ${(currentImage.ocrConfidence! * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(color: AppTheme.primaryTeal, fontWeight: FontWeight.w500),
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
