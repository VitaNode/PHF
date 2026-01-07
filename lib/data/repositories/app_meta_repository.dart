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
  static const String _keyCurrentPersonId = 'current_person_id';
  static const String _keyDisclaimerAccepted = 'is_disclaimer_accepted';
  static const String _keyLockTimeout = 'lock_timeout';

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
    await db.insert(_table, {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
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

  /// 获取当前选择的人员 ID
  Future<String?> getCurrentPersonId() async {
    return get(_keyCurrentPersonId);
  }

  /// 设置当前选择的人员 ID
  Future<void> setCurrentPersonId(String id) async {
    await put(_keyCurrentPersonId, id);
  }

  /// 检查是否已接受免责声明
  Future<bool> isDisclaimerAccepted() async {
    final val = await get(_keyDisclaimerAccepted);
    return val == '1' || val == 'true';
  }

  /// 设置免责声明接受状态
  Future<void> setDisclaimerAccepted(bool accepted) async {
    await put(_keyDisclaimerAccepted, accepted ? '1' : '0');
  }

  /// 获取锁屏超时时间（秒）
  /// 默认 1 分钟 (60s)
  /// 0 表示立即锁定
  Future<int> getLockTimeout() async {
    final val = await get(_keyLockTimeout);
    if (val == null) return 60;
    return int.tryParse(val) ?? 60;
  }

  /// 设置锁屏超时时间（秒）
  Future<void> setLockTimeout(int seconds) async {
    await put(_keyLockTimeout, seconds.toString());
  }
}
