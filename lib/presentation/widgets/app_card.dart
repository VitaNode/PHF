/// # AppCard
///
/// ## Description
/// 标准化卡片组件，统一圆角和边框样式。
///
/// ## Usage
/// ```dart
/// AppCard(
///   child: Column(children: [ ... ]),
///   onTap: () => print('tapped'),
/// )
/// ```
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? AppTheme.bgWhite,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(AppTheme.radiusCard)),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
