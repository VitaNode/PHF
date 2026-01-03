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

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../timeline/timeline_page.dart';
import '../ingestion/ingestion_page.dart';
import '../search/global_search_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../logic/providers/logging_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _onFabPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const IngestionPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = ref.watch(talkerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PaperHealth',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => TalkerScreen(talker: talker),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const GlobalSearchPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Settings Route in Phase 2/3
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: const TimelinePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFabPressed(context),
        backgroundColor: AppTheme.primaryTeal,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }
}
