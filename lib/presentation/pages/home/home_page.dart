// # Home Page
//
// Description
// 主页容器，包含底部导航栏 (BottomNavigationBar) 和主要的页面切换。
//
// Tabs
// - Timeline: 浏览记录 (TimelinePage).
// - Settings: (Phase 2).
//
// FAB
// - 只有在 Timeline Tab 显示悬浮按钮，用于录入新记录。
//
// ## 修复记录
// - [issue#22] 在 AppBar 中增加筛选按钮及过滤状态指示器。

import 'package:flutter/material.dart';
import 'package:phf/presentation/theme/app_theme.dart';
import 'package:phf/presentation/pages/timeline/timeline_page.dart';
import 'package:phf/presentation/pages/ingestion/ingestion_page.dart';
import 'package:phf/presentation/pages/search/global_search_page.dart';
import 'package:phf/presentation/pages/timeline/widgets/filter_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/logic/providers/timeline_provider.dart';
import 'package:phf/presentation/widgets/personnel_tabs.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _onFabPressed(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const IngestionPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineState = ref.watch(timelineControllerProvider).value;
    final hasFilters =
        (timelineState?.filterTags?.isNotEmpty ?? false) ||
        timelineState?.startDate != null ||
        timelineState?.endDate != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PaperHealth',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryTeal,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const GlobalSearchPage(),
                ),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  hasFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                  color: hasFilters
                      ? AppTheme.primaryTeal
                      : AppTheme.textPrimary,
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const TimelineFilterSheet(),
                  );
                },
              ),
              if (hasFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppTheme.errorRed,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const Column(
        children: [
          PersonnelTabs(),
          Expanded(child: TimelinePage()),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFabPressed(context),
        backgroundColor: AppTheme.primaryTeal,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }
}
