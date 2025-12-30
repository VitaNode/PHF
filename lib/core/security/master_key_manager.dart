/// # MasterKeyManager
///
/// ## Description
/// 负责管理应用的根信任凭据（Master Key 和 User Salt）。
/// 使用系统级安全存储 (`flutter_secure_storage`) 进行持久化。
///
/// ## Security Standards
/// - **Master Key**: 32 bytes (256-bit) CSPRNG random.
/// - **User Salt**: 16 bytes (128-bit) CSPRNG random.
/// - **Storage**: Keychain (iOS) / Keystore (Android).
///
/// ## Usage
/// ```dart
/// final manager = MasterKeyManager();
/// final key = await manager.getMasterKey();
/// ```
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MasterKeyManager {
  static const _keyParams = AndroidOptions(encryptedSharedPreferences: true);
  static const _iosParams = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  
  // Storage Keys
  static const String _kMasterKey = 'phf_master_key_v1';
  static const String _kUserSalt = 'phf_user_salt_v1';

  final FlutterSecureStorage _storage;

  MasterKeyManager({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: _keyParams,
          iOptions: _iosParams,
        );

  /// 获取 Master Key (32 bytes)
  ///
  /// 如果不存在，则自动生成并持久化。
  Future<Uint8List> getMasterKey() async {
    return _getOrGenerate(_kMasterKey, 32);
  }

  /// 获取 User Salt (16 bytes)
  ///
  /// 如果不存在，则自动生成并持久化。
  Future<Uint8List> getUserSalt() async {
    return _getOrGenerate(_kUserSalt, 16);
  }

  /// 安全擦除所有密钥数据（用于账户注销）
  Future<void> wipeAll() async {
    await _storage.delete(key: _kMasterKey);
    await _storage.delete(key: _kUserSalt);
  }

  /// 内部通用逻辑：读取 -> (空则生成 -> 保存) -> 返回
  Future<Uint8List> _getOrGenerate(String storageKey, int lengthInBytes) async {
    try {
      String? encodedKey = await _storage.read(key: storageKey);
      if (encodedKey != null) {
        return base64Decode(encodedKey);
      }

      final newKey = _generateRandomBytes(lengthInBytes);
      await _storage.write(key: storageKey, value: base64Encode(newKey));
      return newKey;
    } catch (e) {
      rethrow;
    }
  }

  /// 使用 CSPRNG 生成指定长度的随机字节
  Uint8List _generateRandomBytes(int length) {
    final random = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes;
  }
}
