/// # TagRepository Implementation
///
/// 使用 `databaseService` 访问 `tags` 表。
library;

import '../datasources/local/database_service.dart';
import '../models/tag.dart';
import 'interfaces/tag_repository.dart';

class TagRepository implements ITagRepository {
  final SQLCipherDatabaseService _dbService;

  TagRepository(this._dbService);

  @override
  Future<List<Tag>> getAllTags() async {
    final db = await _dbService.database;
    final maps = await db.query(
      'tags',
      orderBy: 'order_index ASC',
    );
    
    return maps.map((row) => _mapToTag(row)).toList();
  }

  /// 内部映射逻辑
  /// 处理数据库字段 (snake_case, int as bool, ms as DateTime) 与模型之间的转换
  Tag _mapToTag(Map<String, dynamic> row) {
    return Tag(
      id: row['id'] as String,
      personId: row['person_id'] as String?,
      name: row['name'] as String,
      // 容错处理：如果数据库中 color 为 NULL，提供默认 Teal 色
      color: (row['color'] as String?) ?? '#008080',
      // 数据库存储 0/1，转换为 bool。
      // 注意：Model 中字段名为 isSystem，DB 为 is_custom (逻辑反向或命名对齐需求)
      // 种子数据中 is_custom=0 表示系统标签，这里我们根据实际语义对齐
      isSystem: (row['is_custom'] as int? ?? 0) == 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at_ms'] as int),
    );
  }
}