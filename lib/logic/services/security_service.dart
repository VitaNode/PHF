/// # Security Service Implementation
///
/// ## Description
/// 实现基于 `FlutterSecureStorage` 和 `local_auth` 的安全锁管理。
///
/// ## Security Measures
/// - **PIN Hashing**: 使用 SHA-256 对 PIN 进行哈希处理，不存储明文。
/// - **Secure Storage**: 所有安全标志位（Hash, Biometric Flag）均存储在 Keychain (iOS) / Keystore (Android)。
/// - **Memory Safety**: PIN 码明文仅在局部变量中短期存在。
///
/// ## 修复记录
/// - 引入 `Talker` 日志记录，增强可追溯性。
/// - 为关键方法增加 `try-catch` 错误处理。
/// - 在 `_hashPin` 中显式清理字节数组内存，提升安全性。
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../data/repositories/app_meta_repository.dart';
import 'interfaces/security_service.dart';

class SecurityService implements ISecurityService {
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;
  final AppMetaRepository _metaRepo;
  final Talker _talker;

  static const String _keyPinHash = 'user_pin_hash';
  static const String _keyBioEnabled = 'biometrics_enabled';

  SecurityService({
    required FlutterSecureStorage secureStorage,
    required AppMetaRepository metaRepo,
    required Talker talker,
    LocalAuthentication? localAuth,
  }) : _secureStorage = secureStorage,
       _metaRepo = metaRepo,
       _talker = talker,
       _localAuth = localAuth ?? LocalAuthentication();

  @override
  Future<void> setPin(String pin) async {
    try {
      final hash = _hashPin(pin);
      await _secureStorage.write(key: _keyPinHash, value: hash);
      await _metaRepo.setHasLock(true);
      _talker.info('PIN set successfully');
    } catch (e, st) {
      _talker.handle(e, st, 'Error setting PIN');
      rethrow;
    }
  }

  @override
  Future<bool> validatePin(String inputPin) async {
    try {
      final storedHash = await _secureStorage.read(key: _keyPinHash);
      if (storedHash == null) return false;

      final inputHash = _hashPin(inputPin);
      final isValid = storedHash == inputHash;
      if (!isValid) {
        _talker.warning('Invalid PIN attempt');
      }
      return isValid;
    } catch (e, st) {
      _talker.handle(e, st, 'Error validating PIN');
      return false;
    }
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
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e, st) {
      _talker.handle(e, st, 'Error checking biometrics support');
      return false;
    }
  }

  @override
  Future<bool> enableBiometrics() async {
    try {
      // ignore: deprecated_member_use
      final authenticated = await _localAuth.authenticate(
        localizedReason: '验证身份以启用指纹/面容解锁',
        // ignore: deprecated_member_use
        biometricOnly: true,
      );

      if (authenticated) {
        await _secureStorage.write(key: _keyBioEnabled, value: 'true');
        _talker.info('Biometrics enabled successfully');
        return true;
      }
      _talker.warning('Biometrics enabling failed: User not authenticated');
      return false;
    } catch (e, st) {
      _talker.handle(e, st, 'Error enabling biometrics');
      return false;
    }
  }

  @override
  Future<void> disableBiometrics() async {
    try {
      await _secureStorage.delete(key: _keyBioEnabled);
      _talker.info('Biometrics disabled');
    } catch (e, st) {
      _talker.handle(e, st, 'Error disabling biometrics');
    }
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    try {
      final val = await _secureStorage.read(key: _keyBioEnabled);
      return val == 'true';
    } catch (e, st) {
      _talker.handle(e, st, 'Error checking if biometrics is enabled');
      return false;
    }
  }

  @override
  Future<bool> hasLock() async {
    try {
      final storedHash = await _secureStorage.read(key: _keyPinHash);
      return storedHash != null;
    } catch (e, st) {
      _talker.handle(e, st, 'Error checking if lock exists');
      return false;
    }
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    try {
      final digest = sha256.convert(bytes);
      return digest.toString();
    } finally {
      // Memory safety: clear the bytes if possible
      // Note: Uint8List from utf8.encode might be fixed-length and mutable
      for (var i = 0; i < bytes.length; i++) {
        bytes[i] = 0;
      }
    }
  }
}
