import 'package:flutter/material.dart';
import 'security_indicator.dart';

/// # CustomTopBar
///
/// ## Description
/// 全局统一定制的顶部导航栏。
/// 包含返回按钮、标题、以及应用级的加密安全状态展示。
///
/// ## Features
/// - 符合 `Constitution#X. UI/UX` 准则。
/// - 右侧集成 `SecurityIndicator` 展示 100% 离线加密状态。
/// - 支持自定义 Actions 和 Leading Widget。
///
/// ## Security
/// - 仅作状态展示，不处理敏感业务逻辑。
/// - 提示信息清晰，增强用户对“数据离机”的信任感。
class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final Widget? leading;
  final bool isSecure;

  const CustomTopBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.leading,
    this.isSecure = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBack 
          ? (leading ?? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.of(context).maybePop(),
            ))
          : null,
      actions: [
        if (actions != null) ...actions!,
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SecurityIndicator(isSecure: isSecure),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
