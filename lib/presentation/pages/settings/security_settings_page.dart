/// # SecuritySettingsPage Component
///
/// ## Description
/// 隐私与安全设置页面，管理应用锁（PIN 码及生物识别）。
///
/// ## Repair Logs
/// - [2026-01-05] 修复：
///   1. 统一安全操作的错误提示 SnackBar 背景色为 `AppTheme.errorRed`。
///   2. 优化 `_PinInputDialog` 标题字体，应用等宽字体 (Monospace) 规范。
///   3. 增强 UI 健壮性，完善 PIN 码修改流程中的异常捕获与用户反馈。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/providers/security_settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/pin_keyboard.dart';

class SecuritySettingsPage extends ConsumerStatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  ConsumerState<SecuritySettingsPage> createState() =>
      _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends ConsumerState<SecuritySettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(securitySettingsControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('隐私与安全'),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: settingsAsync.when(
        data: (state) => _buildBody(state),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryTeal),
        ),
        error: (e, st) => Center(child: Text('加载失败: $e')),
      ),
    );
  }

  Widget _buildBody(SecuritySettingsState state) {
    return Stack(
      children: [
        ListView(
          children: [
            _buildSectionTitle('应用锁'),
            _buildListTile(
              context,
              icon: Icons.lock_reset_outlined,
              title: '修改 PIN 码',
              subtitle: '更改用于解锁应用的 6 位数字密码',
              onTap: _handleChangePin,
            ),
            if (state.canCheckBiometrics) ...[
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(
                  Icons.fingerprint,
                  color: AppTheme.primaryTeal,
                ),
                title: const Text(
                  '生物识别解锁',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  '启用指纹或面容快速解锁',
                  style: TextStyle(fontSize: 12),
                ),
                value: state.isBiometricsEnabled,
                activeThumbColor: AppTheme.primaryTeal,
                activeTrackColor: AppTheme.primaryTeal.withValues(alpha: 0.4),
                onChanged: state.isLoading
                    ? null
                    : (val) => _handleToggleBiometrics(val),
              ),
            ],
            const SizedBox(height: 24),
            _buildInfoCard(),
          ],
        ),
        if (state.isLoading)
          Container(
            color: Colors.black12,
            child: const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryTeal),
            ),
          ),
      ],
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

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgGray.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: AppTheme.textHint),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'PaperHealth 采用本地加密技术，您的 PIN 码及生物识别信息仅存储在设备的系统安全隔离区，任何第三方（包括开发者）均无法获取。',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleToggleBiometrics(bool enabled) async {
    final success = await ref
        .read(securitySettingsControllerProvider.notifier)
        .toggleBiometrics(enabled);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(enabled ? '启用生物识别失败' : '禁用生物识别失败'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _handleChangePin() async {
    final oldPin = await _showPinDialog(title: '请输入当前 PIN 码');
    if (oldPin == null) return;

    if (!mounted) return;
    final newPin = await _showPinDialog(title: '请输入新 PIN 码');
    if (newPin == null) return;

    if (!mounted) return;
    final confirmPin = await _showPinDialog(title: '请再次输入新 PIN 码');
    if (confirmPin == null) return;

    if (newPin != confirmPin) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('两次输入的新 PIN 码不一致'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
      return;
    }

    final success = await ref
        .read(securitySettingsControllerProvider.notifier)
        .changePin(oldPin, newPin);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'PIN 码修改成功' : '当前 PIN 码错误，修改失败'),
          backgroundColor: success ? AppTheme.successGreen : AppTheme.errorRed,
        ),
      );
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
