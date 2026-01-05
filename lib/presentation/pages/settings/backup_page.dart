/// # BackupPage Component
///
/// ## Description
/// 数据备份与恢复页面，提供加密导出与全量覆盖式恢复。
///
/// ## Repair Logs
/// - [2026-01-05] 修复：
///   1. 统一错误提示 SnackBar 的背景色为 `AppTheme.errorRed`。
///   2. 优化 `_PinInputDialog` 标题字体，确保符合等宽字体 (Monospace) 规范。
///   3. 增强 UI 健壮性，确保所有异常捕获路径均有显式反馈。
library;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/providers/backup_provider.dart';
import '../../../logic/providers/core_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/pin_keyboard.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(backupControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('备份与恢复'),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('数据导出'),
              _buildExportTile(),
              const SizedBox(height: 24),
              _buildSectionTitle('数据恢复'),
              _buildImportTile(),
            ],
          ),
          if (state.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryTeal),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryTeal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryTeal.withValues(alpha: 0.2)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: AppTheme.primaryTeal),
              SizedBox(width: 8),
              Text(
                '安全加密备份',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTeal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '备份文件 (.phbak) 包含您的所有病历记录、照片及标签信息。'
            '备份使用您的 PIN 码进行高强度加密，数据不离开设备，'
            '请务必妥善保管备份文件。',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildExportTile() {
    return Card(
      elevation: 0,
      color: AppTheme.bgGray.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(
          Icons.upload_file_outlined,
          color: AppTheme.primaryTeal,
        ),
        title: const Text('导出当前数据'),
        subtitle: const Text('生成加密备份文件并分享'),
        trailing: const Icon(Icons.chevron_right),
        onTap: _handleExport,
      ),
    );
  }

  Widget _buildImportTile() {
    return Card(
      elevation: 0,
      color: AppTheme.bgGray.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(
          Icons.download_for_offline_outlined,
          color: Colors.orange,
        ),
        title: const Text('恢复备份数据'),
        subtitle: const Text('从 .phbak 文件恢复记录'),
        trailing: const Icon(Icons.chevron_right),
        onTap: _handleImport,
      ),
    );
  }

  Future<void> _handleExport() async {
    final pin = await _showPinDialog(title: '确认 PIN 码以加密导出');
    if (pin != null) {
      final securityService = ref.read(securityServiceProvider);
      final isValid = await securityService.validatePin(pin);
      if (!isValid) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PIN 码错误'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
        return;
      }

      try {
        await ref.read(backupControllerProvider.notifier).exportAndShare(pin);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('备份导出成功')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('导出失败: $e'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleImport() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认恢复备份？'),
        content: const Text(
          '恢复操作将覆盖当前应用内的所有数据！建议在恢复前先导出当前数据进行备份。'
          '\n\n此操作不可撤销.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('确认覆盖'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await FilePicker.platform.pickFiles(
      type:
          FileType.any, // We can't strictly filter .phbak extension in some OS
    );

    if (result == null || result.files.single.path == null) return;
    final path = result.files.single.path!;

    final pin = await _showPinDialog(title: '输入该备份的加密 PIN 码');
    if (pin != null) {
      try {
        await ref
            .read(backupControllerProvider.notifier)
            .importFromFile(path, pin);
        if (mounted) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('恢复成功'),
              content: const Text('备份已成功导入，应用将重新加载。'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Re-launch app logic or just go to home
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('恢复失败: $e'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    }
  }

  Future<String?> _showPinDialog({required String title}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PinInputDialog(title: title),
    );
  }
}

class _PinInputDialog extends StatefulWidget {
  final String title;
  const _PinInputDialog({required this.title});

  @override
  State<_PinInputDialog> createState() => _PinInputDialogState();
}

class _PinInputDialogState extends State<_PinInputDialog> {
  String _pin = '';

  void _onInput(String digit) {
    if (_pin.length < 6) {
      setState(() => _pin += digit);
      if (_pin.length == 6) {
        Navigator.pop(context, _pin);
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: AppTheme.bgWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: AppTheme.fontPool,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                final filled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? AppTheme.primaryTeal : AppTheme.bgGray,
                    border: Border.all(
                      color: filled ? AppTheme.primaryTeal : AppTheme.textHint,
                      width: 1,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 48),
            PinKeyboard(onInput: _onInput, onDelete: _onDelete),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
