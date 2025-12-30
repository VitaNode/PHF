import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// # MainFab
///
/// ## Description
/// 应用级核心操作按钮 (Floating Action Button)。
/// 通常用于开启录入流程 (Ingestion)。
///
/// ## Features
/// - 使用 `AppTheme.primaryTeal` 色调。
/// - 响应式反馈，支持 Hero 动画。
/// - 优雅的视觉阴影与圆角设计。
///
/// ## Usage
/// ```dart
/// Scaffold(
///   floatingActionButton: MainFab(
///     onPressed: () => print('Add new record'),
///     label: '添加病历',
///   ),
/// )
/// ```
class MainFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final String? label;

  const MainFab({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.tooltip,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 24),
        label: Text(
          label!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: AppTheme.fontPool,
          ),
        ),
        backgroundColor: AppTheme.primaryTeal,
        tooltip: tooltip,
        elevation: 6,
        highlightElevation: 2,
        // 符合 Premium 感，使用稍大的圆角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppTheme.primaryTeal,
      foregroundColor: Colors.white,
      tooltip: tooltip,
      elevation: 6,
      highlightElevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, size: 28),
    );
  }
}
