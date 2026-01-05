/// # Privacy Policy Page
///
/// ## Description
/// 离线渲染 Markdown 格式的隐私政策。
/// 确保用户在无网络环境下也能查阅应用的安全与隐私承诺。
///
/// ## Repair Logs
/// - [2026-01-05] 修复：
///   1. 明确在 `MarkdownStyleSheet` 中应用 `AppTheme.fontPool` (Inconsolata)，确保隐私政策符合宪法字体规范。
///   2. 优化 Markdown 渲染样式，统一标题与正文的颜色与行高。
///   3. 修正页面背景色与 AppBar 的一致性。
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../theme/app_theme.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('隐私政策'),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/privacy_policy.md'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryTeal),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('加载失败: ${snapshot.error}'));
          }

          return Markdown(
            data: snapshot.data ?? '',
            selectable: true,
            padding: const EdgeInsets.all(16),
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                fontFamily: AppTheme.fontPool,
              ),
              h2: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTeal,
                height: 2.0,
                fontFamily: AppTheme.fontPool,
              ),
              p: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.6,
                fontFamily: AppTheme.fontPool,
              ),
              strong: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                fontFamily: AppTheme.fontPool,
              ),
              listBullet: const TextStyle(color: AppTheme.primaryTeal),
            ),
          );
        },
      ),
    );
  }
}
