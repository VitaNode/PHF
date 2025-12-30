/// # PathProviderService
///
/// ## Description
/// 管理应用沙盒内的目录结构，确保数据的物理隔离与组织。
///
/// ## Directories
/// - `db`: 存放 SQLite/SQLCipher 数据库文件。
/// - `images`: 存放加密后的媒体资源 (AES-256)。
/// - `temp`: 存放临时解密文件或 OCR 过程中的中间产物。
///
/// ## Security Measures
/// - 所有目录均位于应用私有沙盒 (`ApplicationDocumentsDirectory`) 内。
/// - 提供 `clearTemp()` 机制以符合 `Constitution#I. Privacy` 的清理要求。
library;

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PathProviderService {
  late final Directory _appDocDir;
  late final Directory _dbDir;
  late final Directory _imagesDir;
  late final Directory _tempDir;

  bool _isInitialized = false;

  /// 初始化目录结构
  /// 
  /// 建议在应用启动时 (main.dart) 调用。
  Future<void> initialize() async {
    if (_isInitialized) return;

    _appDocDir = await getApplicationDocumentsDirectory();

    _dbDir = Directory(p.join(_appDocDir.path, 'db'));
    _imagesDir = Directory(p.join(_appDocDir.path, 'images'));
    _tempDir = Directory(p.join(_appDocDir.path, 'temp'));

    // 确保物理目录存在
    await _dbDir.create(recursive: true);
    await _imagesDir.create(recursive: true);
    await _tempDir.create(recursive: true);

    _isInitialized = true;
  }

  String get sandboxRoot {
    _checkInitialized();
    return _appDocDir.path;
  }

  String get dbDirPath {
    _checkInitialized();
    return _dbDir.path;
  }

  String get imagesDirPath {
    _checkInitialized();
    return _imagesDir.path;
  }

  String get tempDirPath {
    _checkInitialized();
    return _tempDir.path;
  }

  /// 获取指定文件名的完整数据库路径
  String getDatabasePath(String fileName) => p.join(dbDirPath, fileName);

  /// 获取相对于应用文档目录的安全文件句柄
  /// [relativePath]: 例如 'images/uuid.enc'
  Future<File> getSecureFile(String relativePath) async {
    _checkInitialized();
    return File(p.join(_appDocDir.path, relativePath));
  }

  /// 清理临时目录
  /// 
  /// 遍历 temp 目录并物理删除所有文件，符合安全清理策略。
  Future<void> clearTemp() async {
    _checkInitialized();
    if (await _tempDir.exists()) {
      await for (final entity in _tempDir.list()) {
        if (entity is File) {
          await entity.delete();
        } else if (entity is Directory) {
          await entity.delete(recursive: true);
        }
      }
    }
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError('PathProviderService must be initialized before use.');
    }
  }
}
