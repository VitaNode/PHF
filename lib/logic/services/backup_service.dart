import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import '../../core/security/master_key_manager.dart';
import '../../core/services/path_provider_service.dart';
import 'interfaces/backup_service.dart';
import 'interfaces/crypto_service.dart';

class BackupService implements IBackupService {
  final ICryptoService _cryptoService;
  final PathProviderService _pathService;
  final MasterKeyManager _keyManager;

  BackupService({
    required ICryptoService cryptoService,
    required PathProviderService pathService,
    required MasterKeyManager keyManager,
  }) : _cryptoService = cryptoService,
       _pathService = pathService,
       _keyManager = keyManager;

  @override
  Future<String> exportBackup(String pin) async {
    // 1. 派生备份密钥
    final key = await _deriveKey(pin);

    // 2. 创建临时打包目录
    final tempDir = Directory(_pathService.tempDirPath);
    final zipPath = p.join(tempDir.path, 'backup_payload.zip');
    final backupPath = p.join(
      tempDir.path,
      'PHF_BACKUP_${DateTime.now().millisecondsSinceEpoch}.phbak',
    );

    // 3. 执行打包 (ZIP)
    final encoder = ZipFileEncoder();
    encoder.create(zipPath);

    // 添加数据库文件
    final dbPath = _pathService.getDatabasePath('phf_encrypted.db');
    final dbFile = File(dbPath);
    if (await dbFile.exists()) {
      await encoder.addFile(dbFile);
    }

    // 添加图片目录
    final imagesDir = Directory(_pathService.imagesDirPath);
    if (await imagesDir.exists()) {
      await encoder.addDirectory(imagesDir);
    }

    await encoder.close();

    try {
      // 4. 对 ZIP 文件执行加密
      await _cryptoService.encryptFile(
        sourcePath: zipPath,
        destPath: backupPath,
        key: key,
      );

      return backupPath;
    } finally {
      // 清理中间未加密的 ZIP
      final f = File(zipPath);
      if (await f.exists()) {
        await f.delete();
      }
    }
  }

  @override
  Future<void> importBackup(String backupFilePath, String pin) async {
    // 1. 派生密钥
    final key = await _deriveKey(pin);

    // 2. 准备解密路径
    final tempDir = Directory(_pathService.tempDirPath);
    final decryptedZipPath = p.join(tempDir.path, 'restored_payload.zip');

    try {
      // 3. 尝试解密
      await _cryptoService.decryptFile(
        sourcePath: backupFilePath,
        destPath: decryptedZipPath,
        key: key,
      );

      // 4. 如果解密成功，停止现有服务
      // 注意：导入备份会覆盖所有现有数据
      // 我们需要通过 Riverpod 让数据库连接断开
      // 这里的逻辑通常由外部 UI 控制在导入前确认
      // 但在服务层，我们确保数据物理落地

      // 5. 解压并覆盖
      final bytes = await File(decryptedZipPath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final sandboxRoot = _pathService.sandboxRoot;

      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          final outFile = File(p.join(sandboxRoot, filename));
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(data);
        } else {
          await Directory(
            p.join(sandboxRoot, filename),
          ).create(recursive: true);
        }
      }
    } catch (e) {
      // 解密失败通常意味着 PIN 错误或文件损坏
      throw Exception('备份恢复失败，请检查 PIN 码是否正确。');
    } finally {
      // 清理临时文件
      final f = File(decryptedZipPath);
      if (await f.exists()) {
        await f.delete();
      }
    }
  }

  /// 使用 PBKDF2 派生 32 字节密钥
  Future<Uint8List> _deriveKey(String pin) async {
    final salt = await _keyManager.getUserSalt();
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256, // 32 bytes
    );

    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(pin.codeUnits),
      nonce: salt,
    );

    final keyBytes = await secretKey.extractBytes();
    return Uint8List.fromList(keyBytes);
  }
}
