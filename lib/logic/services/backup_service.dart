/// # BackupService Implementation
///
/// ## Description
/// 实现基于 ZIP + AES-256-GCM 的离线安全备份。
///
/// ## Repair Logs
/// - [2026-01-05] 修复：
///   1. 增强备份/恢复链路的 Talker 日志细粒度，便于离线排查。
///   2. 优化异常描述，确保用户侧错误提示更具引导性。
/// - [issue#15] 优化内存管理：导入时使用 `InputFileStream` 避免 OOM；增强临时文件清理的可靠性；集成 `Talker` 记录关键链路日志。
/// - [issue#16] 优化恢复逻辑：导入前先行关闭数据库连接 (T3.3.3)；使用 `extractFileToDisk` 实现流式解压，彻底解决 OOM 隐患。
library;

import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import 'package:talker_flutter/talker_flutter.dart';
import '../../core/security/master_key_manager.dart';
import '../../core/services/path_provider_service.dart';
import '../../data/datasources/local/database_service.dart';
import 'interfaces/backup_service.dart';
import 'interfaces/crypto_service.dart';

class BackupService implements IBackupService {
  final ICryptoService _cryptoService;
  final PathProviderService _pathService;
  final MasterKeyManager _keyManager;
  final SQLCipherDatabaseService _dbService;
  final Talker? _talker;

  BackupService({
    required ICryptoService cryptoService,
    required PathProviderService pathService,
    required MasterKeyManager keyManager,
    required SQLCipherDatabaseService dbService,
    Talker? talker,
  }) : _cryptoService = cryptoService,
       _pathService = pathService,
       _keyManager = keyManager,
       _dbService = dbService,
       _talker = talker;

  @override
  Future<String> exportBackup(String pin) async {
    _talker?.info('[BackupService] Starting backup export sequence...');
    // 1. 派生备份密钥
    final key = await _deriveKey(pin);

    // 2. 创建临时打包目录
    final tempDir = Directory(_pathService.tempDirPath);
    final zipPath = p.join(tempDir.path, 'backup_payload.zip');
    final backupPath = p.join(
      tempDir.path,
      'PHF_BACKUP_${DateTime.now().millisecondsSinceEpoch}.phbak',
    );

    try {
      // 3. 执行打包 (ZIP)
      _talker?.info('[BackupService] Bundling files into ZIP...');
      final encoder = ZipFileEncoder();
      encoder.create(zipPath);

      // 添加数据库文件
      final dbPath = _pathService.getDatabasePath('phf_encrypted.db');
      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        await encoder.addFile(dbFile);
      } else {
        _talker?.warning(
          '[BackupService] Database file not found during backup',
        );
      }

      // 添加图片目录
      final imagesDir = Directory(_pathService.imagesDirPath);
      if (await imagesDir.exists()) {
        await encoder.addDirectory(imagesDir);
      }

      await encoder.close();

      // 4. 对 ZIP 文件执行加密
      _talker?.info('[BackupService] Encrypting ZIP with AES-256-GCM...');
      await _cryptoService.encryptFile(
        sourcePath: zipPath,
        destPath: backupPath,
        key: key,
      );

      _talker?.info('[BackupService] Backup export completed: $backupPath');
      return backupPath;
    } catch (e, stack) {
      _talker?.handle(e, stack, '[BackupService] Export failed');
      rethrow;
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
    _talker?.info('[BackupService] Starting backup import sequence...');
    // 1. 派生密钥
    final key = await _deriveKey(pin);

    // 2. 准备解密路径
    final tempDir = Directory(_pathService.tempDirPath);
    final decryptedZipPath = p.join(tempDir.path, 'restored_payload.zip');

    try {
      // 3. 尝试解密
      _talker?.info('[BackupService] Decrypting backup file...');
      await _cryptoService.decryptFile(
        sourcePath: backupFilePath,
        destPath: decryptedZipPath,
        key: key,
      );

      // 4. 重启数据库连接准备：先行关闭现有连接，防止文件占用导致覆盖失败
      _talker?.info('[BackupService] Closing database before restore');
      await _dbService.close();

      // 5. 使用 extractFileToDisk 实现流式解压 (OOM 安全)
      final sandboxRoot = _pathService.sandboxRoot;
      _talker?.info('[BackupService] Extracting files to $sandboxRoot');

      // archive_io 的 extractFileToDisk 在某些版本中可能返回 Future 或同步
      await extractFileToDisk(decryptedZipPath, sandboxRoot);

      _talker?.info('[BackupService] Backup import completed successfully');
    } catch (e, stack) {
      _talker?.handle(e, stack, '[BackupService] Import failed');
      // 解密失败通常意味着 PIN 错误或文件损坏
      throw Exception('备份恢复失败：请检查加密 PIN 码是否正确，或文件是否损坏。');
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
