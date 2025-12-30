/// # Record Detail Page
///
/// ## Description
/// 展示单条医疗记录的详细信息及所有加密图片。
///
/// ## Features
/// - **Metadata**: 医院、日期、备注、所有标签。
/// - **Image Grid**: 网格展示所有缩略图 (`SecureImage`)。
/// - **Interaction**: 点击缩略图进入 `FullImageViewer`。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phf/data/models/image.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/presentation/theme/app_theme.dart';
import 'package:phf/presentation/widgets/secure_image.dart';
import 'package:phf/presentation/widgets/full_image_viewer.dart';
import 'dart:convert';

class RecordDetailPage extends ConsumerStatefulWidget {
  final String recordId;

  const RecordDetailPage({super.key, required this.recordId});

  @override
  ConsumerState<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends ConsumerState<RecordDetailPage> {
  MedicalRecord? _record;
  List<MedicalImage> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recordRepo = ref.read(recordRepositoryProvider);
      final imageRepo = ref.read(imageRepositoryProvider);

      final record = await recordRepo.getRecordById(widget.recordId);
      final images = await imageRepo.getImagesForRecord(widget.recordId);

      if (mounted) {
        setState(() {
          _record = record;
          _images = images;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载详情失败: $e')),
        );
      }
    }
  }

  void _openFullEditor(int initialIndex) {
    if (_images.isEmpty) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullImageViewer(
          images: _images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('错误')),
        body: const Center(child: Text('记录不存在或已被删除')),
      );
    }

    final record = _record!;
    final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(record.notedAt);
    
    // Parse tags
    List<String> tags = [];
    if (record.tagsCache != null) {
      try {
        tags = (jsonDecode(record.tagsCache!) as List).cast<String>();
      } catch (_) {}
    }

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('记录详情'),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Text(
              record.hospitalName ?? '未命名医院',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateStr,
              style: AppTheme.monoStyle.copyWith(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tags
            if (tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.bgGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                )).toList(),
              ),

            // Notes
            if (record.notes != null && record.notes!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                '备注',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.bgGray.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  record.notes!,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ],

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Images Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final image = _images[index];
                return GestureDetector(
                  onTap: () => _openFullEditor(index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SecureImage(
                      imagePath: image.thumbnailPath,
                      encryptionKey: image.encryptionKey, 
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
