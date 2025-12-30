/// # ActiveButton
///
/// ## Description
/// 标准化主操作按钮组件。
///
/// ## Features
/// - 统一圆角 (8px) 和颜色 (Teal)。
/// - 内置 Loading 状态 (`isLoading`)，点击时显示圈圈并禁用交互。
/// - 支持禁用状态。
///
/// ## Usage
/// ```dart
/// ActiveButton(
///   text: 'Save Record',
///   onPressed: () => controller.submit(),
///   isLoading: state.isLoading,
/// )
/// ```
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ActiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDestructive;
  final IconData? icon;

  const ActiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDestructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDestructive ? AppTheme.errorRed : AppTheme.primaryTeal;
    
    return SizedBox(
      height: 48, // Improved touch target
      child: ElevatedButton(
        onPressed: (isLoading || onPressed == null) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}
