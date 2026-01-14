import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../logic/providers/logging_provider.dart';
import '../../theme/app_theme.dart';

/// # FeedbackPage
///
/// ## Repair Logs
/// - [2026-01-08] 修复：初始实现问题反馈页面，支持导出脱敏后的加密日志（Issue #113）。
class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  bool _isLoadingLogs = false;

  Widget _buildInfoSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgGrey,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      child: Text(
        l10n.feedback_info,
        style: const TextStyle(
          height: 1.5,
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryTeal, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textHint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildLogSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.feedback_logs_section,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppTheme.textHint,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoadingLogs ? null : _copyLogsToClipboard,
            icon: _isLoadingLogs
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.copy_all),
            label: Text(
              _isLoadingLogs
                  ? l10n.feedback_logs_exporting
                  : l10n.feedback_logs_copy,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bgGrey,
              foregroundColor: AppTheme.textPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.feedback_logs_hint,
          style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
        ),
      ],
    );
  }

  Future<void> _sendEmail() async {
    final l10n = AppLocalizations.of(context)!;
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'VitaNode@outlook.com',
      query: 'subject=PaperHealth Feedback',
    );
    if (!await launchUrl(emailLaunchUri)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.feedback_error_email)));
      }
    }
  }

  Future<void> _openGitHub() async {
    final l10n = AppLocalizations.of(context)!;
    final Uri url = Uri.parse('https://github.com/VitaNode/PHF/issues');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.feedback_error_browser)));
      }
    }
  }

  Future<void> _copyLogsToClipboard() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoadingLogs = true);
    try {
      final info = await _getDeviceInfo();
      final logs = await ref
          .read(encryptedLogServiceProvider)
          .getDecryptedLogs();

      final clipboardContent =
          '''
=== Device Info ===
$info

=== Logs (Last 7 Days) ===
$logs
''';

      await Clipboard.setData(ClipboardData(text: clipboardContent));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.feedback_copied)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.common_load_failed(e.toString()))),
        );
      }
    } finally {
      setState(() => _isLoadingLogs = false);
    }
  }

  Future<String> _getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();
    String deviceModel = 'Unknown';
    String systemVersion = 'Unknown';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
      systemVersion =
          'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.name;
      systemVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
    }

    return '''
App Version: ${packageInfo.version} (${packageInfo.buildNumber})
Device: $deviceModel
System: $systemVersion
''';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: Text(l10n.settings_feedback),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoSection(l10n),
              const SizedBox(height: 32),
              _buildContactItem(
                icon: Icons.email_outlined,
                title: l10n.feedback_email,
                subtitle: 'VitaNode@outlook.com',
                onTap: _sendEmail,
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                icon: Icons.code,
                title: l10n.feedback_github,
                subtitle: l10n.feedback_github_desc,
                onTap: _openGitHub,
              ),
              const SizedBox(height: 48),
              _buildLogSection(l10n),
            ],
          ),
        ),
      ),
    );
  }
}
