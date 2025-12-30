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
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/logic/providers/timeline_provider.dart';
import 'package:phf/presentation/theme/app_theme.dart';
import 'package:phf/presentation/widgets/event_card.dart';
import 'record_detail_page.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  void _navigateToDetail(BuildContext context, WidgetRef ref, MedicalRecord record) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecordDetailPage(recordId: record.id)),
    );
    // Refresh after return (in case of edits/deletes)
    ref.read(timelineControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRecords = ref.watch(timelineControllerProvider);

    return asyncRecords.when(
      data: (records) {
        if (records.isEmpty) {
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
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final record = records[index];
              final firstImage = record.images.isNotEmpty ? record.images.first : null;
              
              return EventCard(
                record: record,
                firstImage: firstImage,
                onTap: () => _navigateToDetail(context, ref, record),
              );
            },
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