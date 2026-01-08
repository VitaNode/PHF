/// # EncryptedLogService
///
/// ## Description
/// Handles secure logging to local file system.
///
/// ## Features
/// - AES-GCM 256 Encryption.
/// - Log Masking (Sanitization).
/// - File Rotation (Size > 2MB, Age > 7 days).
/// - Decryption for Feedback (Export).
library;

import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'log_key_manager.dart';
import 'log_masking_service.dart';

class EncryptedLogService {
  static const int _maxFileSize = 2 * 1024 * 1024; // 2MB
  static const int _retentionDays = 7;
  static const String _logFileNamePrefix = 'app_logs_';

  final LogKeyManager _keyManager;
    final Cipher _algorithm = AesGcm.with256bits();
  
    EncryptedLogService({LogKeyManager? keyManager})
        : _keyManager = keyManager ?? LogKeyManager();
  
    SecretKey? _cachedKey;
  
    /// Writes a log message securely.
    Future<void> log(String message) async {
      try {
        final masked = LogMaskingService.mask(message);
        final timestamp = DateTime.now().toIso8601String();
        final entry = '[$timestamp] $masked';
  
        final key = await _getSecretKey();
        final file = await _getCurrentLogFile();
  
        // Check size
        if (await file.exists() && await file.length() > _maxFileSize) {
          // Rotate: For now, just delete and recreate to respect the 2MB "clear" rule.
          // Ideally we might roll over, but strict requirement says "clear old or rewrite".
          await file.delete();
        }
  
        // Encrypt
        final bytes = utf8.encode(entry);
        final nonce = _algorithm.newNonce();
        final secretBox = await _algorithm.encrypt(
          bytes,
          secretKey: key,
          nonce: nonce,
        );
  
        // Serialize: Base64(Nonce + CipherText + Mac)
        // AesGcm: CipherText + Mac are separate in Dart's SecretBox, but usually concatenated in standard formats.
        // SecretBox: nonce, cipherText, mac.
        final combined =
            nonce + secretBox.cipherText + secretBox.mac.bytes;
        final line = base64Encode(combined);
  
        await file.writeAsString('$line\n', mode: FileMode.append);
      } catch (e) {
        // Fallback: Print to console if file logging fails (should not happen in prod ideally)
        // ignore: avoid_print
        print('Failed to write secure log: $e');
      }
    }

  /// Retrieves all logs decrypted from the last 7 days.
  Future<String> getDecryptedLogs() async {
    final key = await _getSecretKey();
    final buffer = StringBuffer();
    final dir = await getApplicationDocumentsDirectory();

    // Iterate last 7 days
    for (int i = 0; i < _retentionDays; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateStr = DateFormat('yyyyMMdd').format(date);
      final file = File('${dir.path}/$_logFileNamePrefix$dateStr.txt');

      if (await file.exists()) {
        final lines = await file.readAsLines();
        for (final line in lines) {
          try {
            if (line.isEmpty) continue;
            final data = base64Decode(line);

            // Extract Nonce (12 bytes for AesGcm usually, but verify algorithm)
            // AesGcm nonce length is 12 bytes standard.
            const nonceLength = 12;
            const macLength = 16;

            if (data.length < nonceLength + macLength) continue;

            final nonce = data.sublist(0, nonceLength);
            // Mac is at the end? Or after ciphertext?
            // In my serialization above: Nonce + CipherText + Mac
            final macBytes = data.sublist(data.length - macLength);
            final cipherText = data.sublist(
              nonceLength,
              data.length - macLength,
            );

            final secretBox = SecretBox(
              cipherText,
              nonce: nonce,
              mac: Mac(macBytes),
            );

            final clearBytes = await _algorithm.decrypt(
              secretBox,
              secretKey: key,
            );

            buffer.writeln(utf8.decode(clearBytes));
          } catch (e) {
            buffer.writeln('[Decryption Error]: $e');
          }
        }
      }
    }
    return buffer.toString();
  }

  /// Prunes old logs (Older than 7 days).
  Future<void> pruneOldLogs() async {
    final dir = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = dir.listSync();

    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(days: _retentionDays));
    final dateFormat = DateFormat('yyyyMMdd');

    for (var entity in files) {
      if (entity is File) {
        final filename = entity.uri.pathSegments.last;
        if (filename.startsWith(_logFileNamePrefix) &&
            filename.endsWith('.txt')) {
          try {
            final datePart = filename
                .replaceFirst(_logFileNamePrefix, '')
                .replaceFirst('.txt', '');
            final fileDate = dateFormat.parse(datePart);

            if (fileDate.isBefore(cutoff)) {
              await entity.delete();
            }
          } catch (e) {
            // Ignore parse errors
          }
        }
      }
    }
  }

  Future<SecretKey> _getSecretKey() async {
    if (_cachedKey != null) return _cachedKey!;
    final keyBytes = await _keyManager.getLogKey();
    _cachedKey = SecretKey(keyBytes);
    return _cachedKey!;
  }

  Future<File> _getCurrentLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final dateStr = DateFormat('yyyyMMdd').format(DateTime.now());
    return File('${dir.path}/$_logFileNamePrefix$dateStr.txt');
  }
}
