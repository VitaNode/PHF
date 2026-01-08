/// # Security Onboarding Page
///
/// ## Description
/// 安全引导页，引导用户设置 6 位数字 PIN 码以及（可选）生物识别。
///
/// ## Flow
/// 1. **Step 1**: 输入 PIN 码 (Create PIN)。
/// 2. **Step 2**: 确认 PIN 码 (Confirm PIN)。
/// 3. **Step 3**: 启用生物识别 (Enable Biometrics) - 仅当硬件支持时出现。
/// 4. **Finish**: 完成设置，导航至首页。
///
/// ## Security
/// - PIN 码输入过程中仅保存在内存状态中。
/// - 只有在 Confirm 成功后才调用 `SecurityService.setPin` 进行 Hash 存储。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/providers/auth_provider.dart';
import '../../../logic/providers/core_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/pin_keyboard.dart';

class SecurityOnboardingPage extends ConsumerStatefulWidget {
  const SecurityOnboardingPage({super.key});

  @override
  ConsumerState<SecurityOnboardingPage> createState() =>
      _SecurityOnboardingPageState();
}

class _SecurityOnboardingPageState
    extends ConsumerState<SecurityOnboardingPage> {
  // Logic State
  String _pin = '';
  String _confirmedPin = '';
  bool _isConfirming = false;
  bool _canCheckBiometrics = false;
  bool _showBioStep = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricsSupport();
  }

  Future<void> _checkBiometricsSupport() async {
    final securityService = ref.read(securityServiceProvider);
    final supported = await securityService.canCheckBiometrics();
    setState(() {
      _canCheckBiometrics = supported;
    });
  }

  void _onPinInput(String digit) {
    if (_pin.length >= 6) return;
    setState(() {
      _pin += digit;
    });

    if (_pin.length == 6) {
      _handlePinComplete();
    }
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  void _handlePinComplete() async {
    if (!_isConfirming) {
      // Switch to Confirm Mode
      setState(() {
        _confirmedPin = _pin; // Store first entry
        _pin = ''; // Clear for confirmation
        _isConfirming = true;
      });
    } else {
      // Validate Confirmation
      if (_pin == _confirmedPin) {
        // Success
        await _savePin();
      } else {
        // Mismatch
        setState(() {
          _pin = '';
          _confirmedPin = '';
          _isConfirming = false; // Restart
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('PIN 码不一致，请重新输入')));
        }
      }
    }
  }

  Future<void> _savePin() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final securityService = ref.read(securityServiceProvider);
      await securityService.setPin(_pin);

      if (_canCheckBiometrics) {
        setState(() {
          _showBioStep = true;
          _isProcessing = false;
        });
      } else {
        _finishOnboarding();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _enableBiometrics() async {
    final securityService = ref.read(securityServiceProvider);
    final success = await securityService.enableBiometrics();
    if (success) {
      _finishOnboarding();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('生物识别验证失败或取消')));
      }
    }
  }

  void _finishOnboarding() {
    // 关键：在进入首页前执行解锁，防止全局 builder 立即拦截
    ref.read(authStateControllerProvider.notifier).unlock();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    if (_showBioStep) {
      return _buildBioStep();
    }

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Header
            Text(
              _isConfirming ? '确认 PIN 码' : '创建 PIN 码',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _isConfirming ? '请再次输入以确认' : '为了保护您的隐私，请设置 6 位数字密码',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 48),

            // PIN Dots
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
                    color: filled ? AppTheme.primary : AppTheme.bgGray,
                    border: Border.all(
                      color: filled ? AppTheme.primary : Colors.grey.shade300,
                    ),
                  ),
                );
              }),
            ),

            const Spacer(),

            // Keyboard
            if (!_isProcessing)
              PinKeyboard(onInput: _onPinInput, onDelete: _onDelete),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBioStep() {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, size: 80, color: AppTheme.primary),
              const SizedBox(height: 24),
              const Text(
                '启用生物识别',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '使用 FaceID 或指纹更快捷地解锁应用',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _enableBiometrics,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('立即启用'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _finishOnboarding,
                child: const Text(
                  '稍后设置',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
