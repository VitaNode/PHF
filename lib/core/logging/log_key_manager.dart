/// # LogKeyManager
///
/// ## Description
/// Manages the symmetric key used for encrypting app logs.
/// Uses secure storage to persist the key.
///
/// ## Security
/// - **Log Key**: 32 bytes (256-bit) CSPRNG random.
/// - Storage: Keychain/Keystore.
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogKeyManager {
  static const _keyParams = AndroidOptions();
  static const _iosParams = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  static const String _kLogKey = 'phf_log_key_v1';

  final FlutterSecureStorage _storage;

  LogKeyManager({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: _keyParams,
            iOptions: _iosParams,
          );

  /// Get Log Encryption Key (32 bytes)
  Future<Uint8List> getLogKey() async {
    try {
      final String? encodedKey = await _storage.read(key: _kLogKey);
      if (encodedKey != null) {
        return base64Decode(encodedKey);
      }

      final Uint8List newKey = _generateRandomBytes(32);
      await _storage.write(key: _kLogKey, value: base64Encode(newKey));
      return newKey;
    } catch (e) {
      rethrow;
    }
  }

  Uint8List _generateRandomBytes(int length) {
    final random = Random.secure();
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes;
  }
}
