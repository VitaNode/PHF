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
    final maps = await db.query('tags', orderBy: 'order_index ASC');

    return maps.map((row) => _mapToTag(row)).toList();
  }

  /// 内部映射逻辑
  /// 处理数据库字段 (snake_case, int as bool, ms as DateTime) 与模型之间的转换
  Tag _mapToTag(Map<String, dynamic> row) {
    return Tag(
      id: row['id'] as String,
      personId: row['person_id'] as String?,
      name: row['name'] as String,
      color: (row['color'] as String?) ?? '#008080',
      orderIndex: row['order_index'] as int? ?? 0,
      isCustom: (row['is_custom'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row['created_at_ms'] as int,
      ),
    );
  }
}
