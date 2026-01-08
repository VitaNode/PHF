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
/// ## Repair Logs
/// - [2026-01-08] 修复：支持 AES-256-GCM 加密日志存储、自动滚动与 7 天自动清理（Issue #113）。
library;

import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:synchronized/synchronized.dart';

import 'log_key_manager.dart';
import 'log_masking_service.dart';

class EncryptedLogService {
  static const int _maxFileSize = 2 * 1024 * 1024; // 2MB
  static const int _retentionDays = 7;
  static const String _logFileNamePrefix = 'app_logs_';

  final LogKeyManager _keyManager;
  final Cipher _algorithm = AesGcm.with256bits();
  final Lock _lock = Lock();
  SecretKey? _cachedKey;

  EncryptedLogService({LogKeyManager? keyManager})
    : _keyManager = keyManager ?? LogKeyManager();

  /// Writes a log message securely.
  Future<void> log(String message) async {
    // Use a lock to ensure sequential writes to the file
    await _lock.synchronized(() async {
      try {
        final masked = LogMaskingService.mask(message);
        final timestamp = DateTime.now().toIso8601String();
        final entry = '[$timestamp] $masked';

        final key = await _getSecretKey();
        final file = await _getCurrentLogFile();

        // Check size
        if (await file.exists() && await file.length() > _maxFileSize) {
          // Rotate: For now, just delete and recreate to respect the 2MB "clear" rule.
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
        final combined = nonce + secretBox.cipherText + secretBox.mac.bytes;
        final line = base64Encode(combined);

        await file.writeAsString('$line\n', mode: FileMode.append, flush: true);
      } catch (e) {
        // Fallback: Print to console if file logging fails
        // ignore: avoid_print
        print('Failed to write secure log: $e');
      }
    });
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

      if (!(await file.exists())) continue;

      final lines = await file.readAsLines();

      for (final line in lines) {
        await _processLogLine(line, key, buffer);
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
      if (entity is! File) continue;

      final filename = entity.uri.pathSegments.last;

      if (!filename.startsWith(_logFileNamePrefix) ||
          !filename.endsWith('.txt')) {
        continue;
      }

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

  Future<void> _processLogLine(
    String line,

    SecretKey key,

    StringBuffer buffer,
  ) async {
    try {
      // Remove any whitespace that might have been introduced during writing/reading

      final sanitizedLine = line.replaceAll(RegExp(r'\s+'), '');

      if (sanitizedLine.isEmpty) return;

      // Fix missing padding if truncated

      final paddedLine = _padBase64(sanitizedLine);

      final data = base64Decode(paddedLine);

      // Extract Nonce (12 bytes for AesGcm standard)

      const nonceLength = 12;

      const macLength = 16;

      if (data.length < nonceLength + macLength) {
        throw const FormatException('Data too short for AES-GCM');
      }

      final nonce = data.sublist(0, nonceLength);

      final macBytes = data.sublist(data.length - macLength);

      final cipherText = data.sublist(nonceLength, data.length - macLength);

      final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));

      final clearBytes = await _algorithm.decrypt(secretBox, secretKey: key);

      buffer.writeln(utf8.decode(clearBytes));
    } catch (e) {
      // Include the problematic line snippet if it's a format error to help debugging

      final snippet = line.length > 30 ? '${line.substring(0, 30)}...' : line;

      buffer.writeln('[Decryption Error] ($snippet): $e');
    }
  }

  String _padBase64(String input) {
    if (input.length % 4 == 0) return input;

    return input.padRight(input.length + (4 - (input.length % 4)), '=');
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
