// EventCard Component
//
// Description:
// Timeline 上展示单个就诊记录的卡片组件。
//
// Features:
// - Header: 显示就诊日期 (Inconsolata) 和 医院名称。
// - Body: 使用 SecureImage 展示首张缩略图。
// - Footer: 展示去重后的 Tags 列表。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import '../../data/models/image.dart';
import '../../data/models/record.dart';
import '../../data/models/tag.dart';
import '../../logic/providers/core_providers.dart';
import '../theme/app_theme.dart';
import '../utils/l10n_helper.dart';
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
    final dateStr = _formatDateRange(record.notedAt, record.visitEndDate);
    final allTagsAsync = ref.watch(allTagsProvider);
    final l10n = AppLocalizations.of(context)!;

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
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
                    record.hospitalName ?? l10n.review_edit_hospital_label,
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
              child: allTagsAsync.when(
                data: (allTags) =>
                    _buildImageGrid(context, record.images, allTags),
                loading: () => _buildImageGrid(context, record.images, []),
                error: (_, _) => _buildImageGrid(context, record.images, []),
              ),
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
              child: const Icon(
                Icons.medical_services_outlined,
                color: AppTheme.textHint,
                size: 48,
              ),
            ),

          // 3. Footer (Count info only)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                const Spacer(),
                // Display count of images
                if (record.images.length > 6)
                  Text(
                    '${l10n.common_image_count(record.images.length)} >',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHint,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(
    BuildContext context,
    List<MedicalImage> images,
    List<Tag> allTags,
  ) {
    // Show 4 to 6 images in a grid
    final int displayCount = images.length > 6 ? 6 : images.length;
    final List<MedicalImage> displayImages = images.take(displayCount).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 4.0;
        const int crossAxisCount = 3;
        final double itemSize =
            (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(displayImages.length, (index) {
            final img = displayImages[index];
            final isLast = index == 5 && images.length > 6;

            // Get first tag name
            String? firstTagName;
            if (img.tagIds.isNotEmpty) {
              final firstTag = allTags.firstWhere(
                (t) => t.id == img.tagIds.first,
                orElse: () =>
                    Tag(id: '', name: '', createdAt: DateTime(0), color: ''),
              );
              if (firstTag.name.isNotEmpty) {
                firstTagName = L10nHelper.getTagName(context, firstTag);
              }
            }

            return Stack(
              children: [
                SizedBox(
                  width: itemSize,
                  height: itemSize,
                  child: SecureImage(
                    imagePath: img.thumbnailPath,
                    encryptionKey: img.thumbnailEncryptionKey,
                    borderRadius: BorderRadius.circular(4),
                    fit: BoxFit.cover,
                  ),
                ),
                // Tag Overlay
                if (firstTagName != null)
                  Positioned(
                    left: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        firstTagName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        );
      },
    );
  }

  String _formatDateRange(DateTime start, DateTime? end) {
    final fmtFull = DateFormat('yyyy.MM.dd');
    final fmtDay = DateFormat('MM.dd');

    if (end == null || _isSameDay(start, end)) {
      return fmtFull.format(start);
    } else {
      if (start.year == end.year) {
        return '${fmtFull.format(start)} - ${fmtDay.format(end)}';
      } else {
        return '${fmtFull.format(start)} - ${fmtFull.format(end)}';
      }
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
