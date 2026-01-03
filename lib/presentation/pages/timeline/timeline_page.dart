/// # Timeline Page
///
/// ## Description
/// 首页时间轴页面，展示用户的医疗记录列表。
///
/// ## Features
/// - **List View**: 使用 `EventCard` 展示记录摘要。
/// - **Pull to Refresh**: 下拉刷新列表。
/// - **Navigation**: 点击卡片调整至详情页。
/// - **Empty State**: 无记录时展示引导提示。
/// 
/// ## Repair Logs
/// - [2025-12-31] 修复：修正 MaterialPageRoute 类型推导警告。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/logic/providers/timeline_provider.dart';
import 'package:phf/presentation/theme/app_theme.dart';
import 'package:phf/presentation/widgets/event_card.dart';
import 'widgets/pending_review_banner.dart';
import 'record_detail_page.dart';
import '../review/review_list_page.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  void _navigateToDetail(BuildContext context, WidgetRef ref, MedicalRecord record) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => RecordDetailPage(recordId: record.id)),
    );
    // Refresh after return (in case of edits/deletes)
    await ref.read(timelineControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHomeState = ref.watch(timelineControllerProvider);

    return asyncHomeState.when(
      data: (homeState) {
        final records = homeState.records;
        
        if (records.isEmpty && homeState.pendingCount == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.textHint),
                const SizedBox(height: 16),
                const Text(
                  '暂无记录，点击右下角 + 号开始录入',
                  style: TextStyle(color: AppTheme.textHint),
                ),
                TextButton(
                  onPressed: () => ref.read(timelineControllerProvider.notifier).refresh(),
                  child: const Text('刷新'),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(timelineControllerProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              if (homeState.pendingCount > 0)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: PendingReviewBanner(
                      count: homeState.pendingCount,
                      onTap: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const ReviewListPage()),
                        );
                      },
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final record = records[index];
                      final firstImage = record.images.isNotEmpty ? record.images.first : null;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: EventCard(
                          record: record,
                          firstImage: firstImage,
                          onTap: () => _navigateToDetail(context, ref, record),
                        ),
                      );
                    },
                    childCount: records.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppTheme.errorRed, size: 48),
            const SizedBox(height: 16),
            Text('加载失败: $err', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(timelineControllerProvider.notifier).refresh(),
              child: const Text('重试'),
            )
          ],
        ),
      ),
    );
  }
}