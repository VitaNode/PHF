// EventCard Component
//
// Description:
// Timeline 上展示单个就诊记录的卡片组件。
//
// Features:
// - Header: 显示就诊日期 (Inconsolata) 和 医院名称。
// - Body: 使用 SecureImage 展示首张缩略图。
// - Footer: 展示去重后的 Tags 列表。

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/image.dart';
import '../../data/models/record.dart';
import '../../data/models/tag.dart';
import '../../logic/providers/core_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/secure_image.dart';

class EventCard extends ConsumerWidget {
  final MedicalRecord record;
  final MedicalImage? firstImage;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.record,
    this.firstImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr = DateFormat('yyyy-MM-dd').format(record.notedAt);
    
    // Parse tags from JSON cache
    final List<String> tags = _parseTags(record.tagsCache);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero, // Custom layout inside
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header (Date + Hospital)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                // Date Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.bgGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    dateStr,
                    style: AppTheme.monoStyle.copyWith(
                      fontSize: 12,
                      color: AppTheme.textHint,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Hospital Name
                Expanded(
                  child: Text(
                    record.hospitalName ?? '未命名记录',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 2. Body (Thumbnail Grid)
          if (record.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _buildImageGrid(record.images),
            )
          else
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.bgGray,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.medical_services_outlined, color: AppTheme.textHint, size: 48),
            ),

          // 3. Footer (Single Styled Tag)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                if (tags.isNotEmpty)
                  _buildTagChip(tags.first),
                const Spacer(),
                // Display count of images
                if (record.images.length > 6)
                   Text(
                     '共 ${record.images.length} 张图片 >',
                     style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
                   ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<MedicalImage> images) {
    // Show 4 to 6 images in a grid
    final int displayCount = images.length > 6 ? 6 : images.length;
    final List<MedicalImage> displayImages = images.take(displayCount).toList();

    return LayoutBuilder(builder: (context, constraints) {
      final double spacing = 4.0;
      final int crossAxisCount = 3;
      final double itemSize = (constraints.maxWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(displayImages.length, (index) {
          final isLast = index == 5 && images.length > 6;
          
          return Stack(
            children: [
              SizedBox(
                width: itemSize,
                height: itemSize,
                child: SecureImage(
                  imagePath: displayImages[index].thumbnailPath,
                  encryptionKey: displayImages[index].thumbnailEncryptionKey,
                  borderRadius: BorderRadius.circular(4),
                  fit: BoxFit.cover,
                ),
              ),
              if (isLast)
                Container(
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      '...',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          );
        }),
      );
    });
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withValues(alpha: 0.1),
        border: Border.all(color: AppTheme.primaryLight.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppTheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  List<String> _parseTags(String? jsonCache) {
    if (jsonCache == null || jsonCache.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonCache) as List<dynamic>;
      return list.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }
}