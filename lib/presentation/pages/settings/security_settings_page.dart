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
import 'package:phf/generated/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: Text(l10n.settings_privacy_security),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: settingsAsync.when(
        data: (state) => _buildBody(state),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryTeal),
        ),
        error: (e, st) =>
            Center(child: Text(l10n.common_load_failed(e.toString()))),
      ),
    );
  }

  Widget _buildBody(SecuritySettingsState state) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        ListView(
          children: [
            _buildSectionTitle(l10n.settings_security_app_lock),
            _buildListTile(
              context,
              icon: Icons.lock_reset_outlined,
              title: l10n.settings_security_change_pin,
              subtitle: l10n.settings_security_change_pin_desc,
              onTap: _handleChangePin,
            ),
            const Divider(height: 1),
            _buildLockTimeoutTile(context, state),
            if (state.canCheckBiometrics) ...[
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(
                  Icons.fingerprint,
                  color: AppTheme.primaryTeal,
                ),
                title: Text(
                  l10n.settings_security_biometrics,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  l10n.settings_security_biometrics_desc,
                  style: const TextStyle(fontSize: 12),
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
            _buildInfoCard(l10n),
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

  Widget _buildLockTimeoutTile(
    BuildContext context,
    SecuritySettingsState state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.timer_outlined, color: AppTheme.primaryTeal),
      title: Text(
        l10n.settings_security_lock_timeout,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '当前设置: ${_getLockTimeoutText(context, state.lockTimeout)}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => _showLockTimeoutDialog(context, state.lockTimeout),
    );
  }

  String _getLockTimeoutText(BuildContext context, int seconds) {
    final l10n = AppLocalizations.of(context)!;
    if (seconds <= 0) return l10n.settings_security_timeout_immediate;
    if (seconds == 60) return l10n.settings_security_timeout_1min;
    if (seconds == 300) return l10n.settings_security_timeout_5min;
    return l10n.settings_security_timeout_custom(seconds ~/ 60);
  }

  void _showLockTimeoutDialog(BuildContext context, int currentTimeout) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settings_security_lock_timeout),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimeoutOption(
              context,
              l10n.settings_security_timeout_immediate,
              0,
              currentTimeout,
            ),
            _buildTimeoutOption(
              context,
              l10n.settings_security_timeout_1min,
              60,
              currentTimeout,
            ),
            _buildTimeoutOption(
              context,
              l10n.settings_security_timeout_5min,
              300,
              currentTimeout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeoutOption(
    BuildContext context,
    String label,
    int seconds,
    int currentTimeout,
  ) {
    return RadioListTile<int>(
      title: Text(label),
      value: seconds,
      // ignore: deprecated_member_use
      groupValue: currentTimeout,
      activeColor: AppTheme.primaryTeal,
      // ignore: deprecated_member_use
      onChanged: (val) {
        if (val != null) {
          ref
              .read(securitySettingsControllerProvider.notifier)
              .updateLockTimeout(val);
          Navigator.pop(context);
        }
      },
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

  Widget _buildInfoCard(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgGray.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20, color: AppTheme.textHint),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.settings_security_info_card,
              style: const TextStyle(
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
    final l10n = AppLocalizations.of(context)!;
    final success = await ref
        .read(securitySettingsControllerProvider.notifier)
        .toggleBiometrics(enabled);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? l10n.settings_security_biometrics_enabled_failed
                : l10n.settings_security_biometrics_disabled_failed,
          ),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _handleChangePin() async {
    final l10n = AppLocalizations.of(context)!;
    final oldPin = await _showPinDialog(
      title: l10n.settings_security_pin_current,
    );
    if (oldPin == null) return;
    if (!mounted) return;
    final newPin = await _showPinDialog(title: l10n.settings_security_pin_new);
    if (newPin == null) return;
    if (!mounted) return;
    final confirmPin = await _showPinDialog(
      title: l10n.settings_security_pin_confirm,
    );
    if (confirmPin == null) return;
    if (newPin != confirmPin) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settings_security_pin_mismatch),
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
          content: Text(
            success
                ? l10n.settings_security_pin_success
                : l10n.settings_security_pin_error,
          ),
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
