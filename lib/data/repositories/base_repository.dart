/// # BaseRepository
///
/// ## Description
/// 所有 Repository 的基类，提供统一的数据库服务访问入口。
///
/// ## Architecture
/// 属于 Data Layer，持有 `SQLCipherDatabaseService` 的引用。
library;

import 'package:phf/data/models/image.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../datasources/local/database_service.dart';
import 'mappers/entity_mapper.dart';

abstract class BaseRepository with EntityMapper {
  final SQLCipherDatabaseService dbService;

  BaseRepository(this.dbService);

  /// 获取数据库执行器（支持事务）
  /// 如果提供了 [executor]，则使用它；否则获取全局数据库实例。
  Future<DatabaseExecutor> getExecutor([DatabaseExecutor? executor]) async {
    if (executor != null) return executor;
    return dbService.database;
  }

  /// 批量抓取多个 Record 的图片，并按 record_id 分组 (N+1 优化)
  Future<Map<String, List<MedicalImage>>> fetchImagesForRecords(
    DatabaseExecutor exec,
    List<String> recordIds,
  ) async {
    if (recordIds.isEmpty) return {};

    final String placeholders = List.filled(recordIds.length, '?').join(',');
    final List<Map<String, dynamic>> imageMaps = await exec.query(
      'images',
      where: 'record_id IN ($placeholders)',
      whereArgs: recordIds,
      orderBy: 'page_index ASC',
    );

    final Map<String, List<MedicalImage>> imagesByRecord = {};
    for (var row in imageMaps) {
      final rid = row['record_id'] as String;
      imagesByRecord.putIfAbsent(rid, () => []);
      imagesByRecord[rid]!.add(mapToImage(row));
    }
    return imagesByRecord;
  }
}
