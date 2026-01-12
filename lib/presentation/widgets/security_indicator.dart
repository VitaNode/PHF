/// # SecurityIndicator
///
/// ## Description
/// 隐私安全状态指示器。
/// 在敏感操作页面（如病历详情页底部）展示，增强用户信任。
///
/// ## Visuals
/// - Icon: Lock / Shield
/// - Color: Teal / Grey
/// - Text: "AES-256 Encrypted on Device"
library;

import 'package:flutter/material.dart';

import 'package:phf/generated/l10n/app_localizations.dart';

import '../theme/app_theme.dart';

class SecurityIndicator extends StatelessWidget {
  final bool isSecure;

  const SecurityIndicator({super.key, this.isSecure = true});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),

      decoration: BoxDecoration(
        color: AppTheme.bgGrey,

        borderRadius: BorderRadius.circular(20), // Pill shape

        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            isSecure ? Icons.lock : Icons.lock_open,

            size: 14,

            color: isSecure ? AppTheme.primaryTeal : AppTheme.warningOrange,
          ),

          const SizedBox(width: 6),

          Text(
            isSecure
                ? l10n.security_status_encrypted
                : l10n.security_status_unverified,

            style: const TextStyle(
              fontSize: 10,

              fontWeight: FontWeight.w600,

              color: AppTheme.textGrey,

              fontFamily: AppTheme.fontPool,
            ),
          ),
        ],
      ),
    );
  }
}
