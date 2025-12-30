/// # FileSecurityHelper Implementation
///
/// ## Description
/// 文件安全操作的高级封装。
/// 负责协调：
/// 1. 随机密钥生成 (via CryptoService)。
/// 2. 目标文件路径规划 (UUID)。
/// 3. 调用底层流式加密/解密。
///
/// ## Usage
/// ```dart
/// final helper = FileSecurityHelper(cryptoService: service);
/// final result = await helper.encryptMedia(sourceFile, targetDir: '/path/to/sandbox/images');
/// ```
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../../logic/services/interfaces/crypto_service.dart';
import 'encrypted_file_result.dart';

class FileSecurityHelper {
  final ICryptoService _cryptoService;
  final Uuid _uuid;

  FileSecurityHelper({
    required ICryptoService cryptoService,
    Uuid? uuid,
  })  : _cryptoService = cryptoService,
        _uuid = uuid ?? const Uuid();

  /// 加密媒体文件
  ///
  /// [sourceFile]: 原始输入文件/临时文件。
  /// [targetDir]: 加密后的文件存放目录（绝对路径）。
  /// 
  /// Returns: 用于存储到 DB 的相对路径和 Base64 Key。
  Future<EncryptedFileResult> encryptMedia(
    File sourceFile, {
    required String targetDir,
  }) async {
    // 1. Generate Key
    final keyBytes = _cryptoService.generateRandomKey();
    final base64Key = base64Encode(keyBytes);

    // 2. Determine Output Path
    final fileName = '${_uuid.v4()}.enc';
    final destPath = '$targetDir/$fileName';
    
    // Ensure parent directory exists
    final dir = Directory(targetDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    // 3. Encrypt Stream
    await _cryptoService.encryptFile(
      sourcePath: sourceFile.path,
      destPath: destPath,
      key: keyBytes,
    );

    // 4. Return Result (path is relative filename for now, logic layer handles full path usually, 
    // but here we return relative filename to be flexible)
    // 根据 Spec 的习惯，这里返回文件名，Data 层再拼接入库
    return EncryptedFileResult(
      relativePath: fileName,
      base64Key: base64Key,
    );
  }

  /// 直接加密内存数据到文件
  ///
  /// [data]: 原始数据字节。
  /// [targetDir]: 目标目录绝对路径。
  Future<EncryptedFileResult> saveEncryptedFile({
    required Uint8List data,
    required String targetDir,
  }) async {
    // 1. Generate Key
    final keyBytes = _cryptoService.generateRandomKey();
    final base64Key = base64Encode(keyBytes);

    // 2. Determine Output Path
    final fileName = '${_uuid.v4()}.enc';
    final destPath = '$targetDir/$fileName';

    // Ensure directory exists
    final dir = Directory(targetDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    // 3. Encrypt Data directly to File
    final encryptedPacket = await _cryptoService.encrypt(
      data: data, 
      key: keyBytes,
    );
    
    final file = File(destPath);
    await file.writeAsBytes(encryptedPacket);

    return EncryptedFileResult(
      relativePath: fileName,
      base64Key: base64Key,
    );
  }

  /// 解密文件到临时目录
  ///
  /// [encryptedPath]: 加密文件的绝对路径。
  /// [base64Key]: 对应的 Base64 密钥。
  /// [tempDir]: 临时解密文件存放目录。
  ///
  /// Returns: 解密后的 File 句柄。调用者需负责最后的清理 (secureWipe)。
  Future<File> decryptToTemp(
    String encryptedPath,
    String base64Key, {
    required String tempDir,
  }) async {
    final keyBytes = base64Decode(base64Key);
    final tempFileName = '${_uuid.v4()}.tmp';
    final destPath = '$tempDir/$tempFileName';

    await _cryptoService.decryptFile(
      sourcePath: encryptedPath,
      destPath: destPath,
      key: keyBytes,
    );

    return File(destPath);
  }

  /// 直接解密文件到内存
  ///
  /// [path]: 加密文件的绝对路径。
  /// [base64Key]: 对应的 Base64 密钥。
  ///
  /// Returns: 解密后的原始数据。
  Future<Uint8List> decryptDataFromFile(String path, String base64Key) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileNotFoundException(path);
    }
    
    final encryptedData = await file.readAsBytes();
    final keyBytes = base64Decode(base64Key);

    return _cryptoService.decrypt(
      encryptedData: encryptedData, 
      key: keyBytes,
    );
  }
}

class FileNotFoundException implements Exception {
  final String path;
  FileNotFoundException(this.path);
  @override
  String toString() => 'FileNotFoundException: $path';
}
