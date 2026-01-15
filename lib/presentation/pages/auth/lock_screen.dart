import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import '../../../logic/providers/core_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/pin_keyboard.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.lock_screen_error),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.primaryTeal,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      const Icon(
                        Icons.lock_outline,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'PaperHealth',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.lock_screen_title,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Pin Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final bool filled = index < _pin.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: filled
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.3),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      // Number Pad
                      PinKeyboard(
                        onInput: _onPinInput,
                        onDelete: _onDelete,
                        textColor: Colors.white,
                        buttonBackgroundColor: Colors.white.withValues(
                          alpha: 0.1,
                        ),
                      ),
                      if (_canCheckBiometrics) ...[
                        const SizedBox(height: 24),
                        IconButton(
                          icon: const Icon(
                            Icons.fingerprint,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: _authenticateWithBiometrics,
                          tooltip: l10n.lock_screen_biometric_tooltip,
                        ),
                      ],
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
