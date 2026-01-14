import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:phf/logic/providers/locale_provider.dart';
import '../../theme/app_theme.dart';
import 'backup_page.dart';
import 'feedback_page.dart';
import 'personnel_management_page.dart';
import 'privacy_policy_page.dart';
import 'security_settings_page.dart';
import 'tag_management_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: Text(l10n.settings_title),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionTitle(l10n.settings_section_profiles),
          _buildListTile(
            context,
            icon: Icons.people_outline,
            title: l10n.settings_manage_profiles,
            subtitle: l10n.settings_manage_profiles_desc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const PersonnelManagementPage(),
              ),
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.label_outline,
            title: l10n.settings_tag_library,
            subtitle: l10n.settings_tag_library_desc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const TagManagementPage(),
              ),
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.language_outlined,
            title: l10n.settings_language,
            subtitle: l10n.settings_language_desc,
            onTap: () => _showLanguagePicker(context, ref),
          ),
          const Divider(),
          _buildSectionTitle(l10n.settings_section_security),
          _buildListTile(
            context,
            icon: Icons.security_outlined,
            title: l10n.settings_privacy_security,
            subtitle: l10n.settings_privacy_security_desc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const SecuritySettingsPage(),
              ),
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.backup_outlined,
            title: l10n.settings_backup_restore,
            subtitle: l10n.settings_backup_restore_desc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const BackupPage()),
            ),
          ),
          const Divider(),
          _buildSectionTitle(l10n.settings_section_support),
          _buildListTile(
            context,
            icon: Icons.feedback_outlined,
            title: l10n.settings_feedback,
            subtitle: l10n.settings_feedback_desc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const FeedbackPage()),
            ),
          ),
          const Divider(),
          _buildSectionTitle(l10n.settings_section_about),
          _buildListTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: l10n.settings_privacy_policy,
            subtitle: l10n.settings_privacy_policy_desc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const PrivacyPolicyPage(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: AppTheme.primaryTeal,
            ),
            title: Text(
              l10n.settings_version,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('PaperHealth v1.0.0'),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final Map<String, String> languages = {
      'system': '跟随系统 (Follow System)',
      'en': 'English',
      'zh': '中文 (Chinese)',
      'es': 'Español (Spanish)',
      'pt': 'Português (Portuguese)',
      'id': 'Bahasa Indonesia (Indonesian)',
      'vi': 'Tiếng Việt (Vietnamese)',
      'th': 'ไทย (Thai)',
      'hi': 'हिन्दी (Hindi)',
    };

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.settings_language,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: languages.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.value),
                      onTap: () {
                        final code = entry.key == 'system' ? null : entry.key;
                        ref
                            .read(localeControllerProvider.notifier)
                            .setLocale(code);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.textHint,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryTeal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
