/// # AppMeta Repository
///
/// ## Description
/// 负责存取 `app_meta` 表中的键值对配置。
/// 主要用于存储非敏感的系统状态标志（如：onboarding_completed, has_lock_enabled）。
///
/// ## Usage
/// ```dart
/// final repo = ref.read(appMetaRepositoryProvider);
/// await repo.setHasLock(true);
/// final enabled = await repo.hasLock();
/// ```
library;

import 'package:sqflite_sqlcipher/sqflite.dart';
import '../datasources/local/database_service.dart';

class AppMetaRepository {
  final SQLCipherDatabaseService _dbService;

  AppMetaRepository(this._dbService);

  static const String _table = 'app_meta';
  static const String _keyHasLock = 'has_lock';

  /// 通用读取
  Future<String?> get(String key) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _table,
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  /// 通用写入
  Future<void> put(String key, String value) async {
    final db = await _dbService.database;
    await db.insert(
      _table,
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 检查是否已设置应用锁
  Future<bool> hasLock() async {
    final val = await get(_keyHasLock);
    return val == '1' || val == 'true';
  }

  /// 设置应用锁状态
  Future<void> setHasLock(bool enabled) async {
    await put(_keyHasLock, enabled ? '1' : '0');
  }
}
