import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/providers/core_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/pin_keyboard.dart';

/// # LockScreen
///
/// ## Description
/// 应用锁界面。在冷启动或从后台恢复时显示，要求用户进行身份验证。
class LockScreen extends ConsumerStatefulWidget {
  final VoidCallback onAuthenticated;

  const LockScreen({super.key, required this.onAuthenticated});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with WidgetsBindingObserver {
  String _pin = '';
  bool _isProcessing = false;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initBiometrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _authenticateWithBiometrics();
    }
  }

  Future<void> _initBiometrics() async {
    final securityService = ref.read(securityServiceProvider);
    final canCheck = await securityService.canCheckBiometrics();
    final isEnabled = await securityService.isBiometricsEnabled();
    if (mounted) {
      setState(() {
        _canCheckBiometrics = canCheck && isEnabled;
      });
    }
    if (_canCheckBiometrics) {
      await _authenticateWithBiometrics();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (!_canCheckBiometrics || _isProcessing) return;

    final securityService = ref.read(securityServiceProvider);
    // 这里的 enableBiometrics 实际上是执行一次认证
    // 建议将来在 SecurityService 中拆分出 authenticate 方法
    final success = await securityService.enableBiometrics();
    if (success && mounted) {
      widget.onAuthenticated();
    }
  }

  void _onPinInput(String digit) {
    if (_pin.length >= 6) return;
    setState(() {
      _pin += digit;
    });

    if (_pin.length == 6) {
      _validatePin();
    }
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  Future<void> _validatePin() async {
    setState(() => _isProcessing = true);
    final securityService = ref.read(securityServiceProvider);
    final isValid = await securityService.validatePin(_pin);

    if (isValid) {
      widget.onAuthenticated();
    } else {
      setState(() {
        _pin = '';
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PIN 码错误，请重新输入')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Icon(Icons.lock_outline, size: 48, color: AppTheme.primary),
            const SizedBox(height: 24),
            const Text(
              '请输入 PIN 码解锁',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
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

            const SizedBox(height: 32),

            // Biometric Trigger
            if (_canCheckBiometrics && !_isProcessing)
              IconButton(
                onPressed: _authenticateWithBiometrics,
                icon: const Icon(Icons.face, size: 40, color: AppTheme.primary),
                tooltip: '使用生物识别解锁',
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
}
