/// # Security Service Implementation
///
/// ## Description
/// 实现基于 `FlutterSecureStorage` 和 `local_auth` 的安全锁管理。
///
/// ## Security Measures
/// - **PIN Hashing**: 使用 SHA-256 对 PIN 进行哈希处理，不存储明文。
/// - **Secure Storage**: 所有安全标志位（Hash, Biometric Flag）均存储在 Keychain (iOS) / Keystore (Android)。
/// - **Memory Safety**: PIN 码明文仅在局部变量中短期存在。
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../data/repositories/app_meta_repository.dart';
import 'interfaces/security_service.dart';

class SecurityService implements ISecurityService {
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;
  final AppMetaRepository _metaRepo;

  static const String _keyPinHash = 'user_pin_hash';
  static const String _keyBioEnabled = 'biometrics_enabled';

  SecurityService({
    required FlutterSecureStorage secureStorage,
    required AppMetaRepository metaRepo,
    LocalAuthentication? localAuth,
  }) : _secureStorage = secureStorage,
       _metaRepo = metaRepo,
       _localAuth = localAuth ?? LocalAuthentication();

  @override
  Future<void> setPin(String pin) async {
    final hash = _hashPin(pin);
    await _secureStorage.write(key: _keyPinHash, value: hash);
    await _metaRepo.setHasLock(true);
  }

  @override
  Future<bool> validatePin(String inputPin) async {
    final storedHash = await _secureStorage.read(key: _keyPinHash);
    if (storedHash == null) return false;

    final inputHash = _hashPin(inputPin);
    return storedHash == inputHash;
  }

  @override
  Future<bool> changePin(String oldPin, String newPin) async {
    final isValid = await validatePin(oldPin);
    if (!isValid) return false;

    await setPin(newPin);
    return true;
  }

  @override
  Future<bool> canCheckBiometrics() async {
    final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final bool isDeviceSupported = await _localAuth.isDeviceSupported();
    return canCheckBiometrics && isDeviceSupported;
  }

  @override
  Future<bool> enableBiometrics() async {
    try {
      // 兼容较旧版本的 local_auth API 或特定配置
      // ignore: deprecated_member_use
      final authenticated = await _localAuth.authenticate(
        localizedReason: '验证身份以启用指纹/面容解锁',
        // ignore: deprecated_member_use
        biometricOnly: true,
      );

      if (authenticated) {
        await _secureStorage.write(key: _keyBioEnabled, value: 'true');
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> disableBiometrics() async {
    await _secureStorage.delete(key: _keyBioEnabled);
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    final val = await _secureStorage.read(key: _keyBioEnabled);
    return val == 'true';
  }

  @override
  Future<bool> hasLock() async {
    final storedHash = await _secureStorage.read(key: _keyPinHash);
    return storedHash != null;
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
