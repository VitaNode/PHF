import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'backup_page.dart';
import 'personnel_management_page.dart';
import 'security_settings_page.dart';
import 'tag_management_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionTitle('档案与分类'),
          _buildListTile(
            context,
            icon: Icons.people_outline,
            title: '管理档案',
            subtitle: '添加或编辑人员档案',
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
            title: '标签库管理',
            subtitle: '维护病历分类标签',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const TagManagementPage(),
              ),
            ),
          ),
          const Divider(),
          _buildSectionTitle('数据安全'),
          _buildListTile(
            context,
            icon: Icons.security_outlined,
            title: '隐私与安全',
            subtitle: '修改 PIN 码及生物识别',
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
            title: '备份与恢复',
            subtitle: '导出加密备份文件',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const BackupPage()),
            ),
          ),
        ],
      ),
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
