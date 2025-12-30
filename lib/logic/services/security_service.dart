/// # Security Service
///
/// ## Description
/// 核心安全业务逻辑服务。
/// 负责处理应用锁 (PIN / Biometrics) 的设置、验证与状态管理。
///
/// ## Logic
/// - **PIN**: 使用 SHA-256 哈希后存储在 Keychain/Keystore (FlutterSecureStorage)。
/// - **Biometrics**: 使用 `local_auth` 调用原生生物识别。
/// - **State**: 成功设置后，更新 `AppMetaRepository` 中的 `has_lock` 标记。
///
/// ## Security
/// - PIN 码明文仅在内存短暂存在，不落盘。
/// - 只有 Hash 值被持久化。
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../data/repositories/app_meta_repository.dart';

class SecurityService {
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;
  final AppMetaRepository _metaRepo;

  static const String _keyPinHash = 'user_pin_hash';
  static const String _keyBioEnabled = 'biometrics_enabled';

  SecurityService({
    required FlutterSecureStorage secureStorage,
    required AppMetaRepository metaRepo,
    LocalAuthentication? localAuth,
  })  : _secureStorage = secureStorage,
        _metaRepo = metaRepo,
        _localAuth = localAuth ?? LocalAuthentication();

  /// 设置新的 PIN 码
  ///
  /// 1. 计算 SHA-256 Hash。
  /// 2. 存入 Secure Storage。
  /// 3. 更新 DB 状态 `has_lock = true`。
  Future<void> setPin(String pin) async {
    final hash = _hashPin(pin);
    await _secureStorage.write(key: _keyPinHash, value: hash);
    await _metaRepo.setHasLock(true);
  }

  /// 验证 PIN 码
  Future<bool> validatePin(String inputPin) async {
    final storedHash = await _secureStorage.read(key: _keyPinHash);
    if (storedHash == null) return false;

    final inputHash = _hashPin(inputPin);
    return storedHash == inputHash;
  }

  /// 检查是否支持生物识别
  Future<bool> canCheckBiometrics() async {
    final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final bool isDeviceSupported = await _localAuth.isDeviceSupported();
    return canCheckBiometrics && isDeviceSupported;
  }

  /// 启用生物识别
  ///
  /// 需先调用 `canCheckBiometrics` 检查硬件支持。
  /// 成功认证一次后，标记 `biometrics_enabled = true` 到 SecureStorage。
  Future<bool> enableBiometrics() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: '验证身份以启用指纹/面容解锁',
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

  /// 检查是否已启用生物识别
  Future<bool> isBiometricsEnabled() async {
    final val = await _secureStorage.read(key: _keyBioEnabled);
    return val == 'true';
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
