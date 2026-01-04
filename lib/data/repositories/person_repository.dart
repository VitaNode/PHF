/// # PersonRepository
///
/// ## Description
/// 实现 IPersonRepository，负责 Person 实体的数据库操作。
///
/// ## Implementation
/// - 查询 `persons` 表。
/// - 处理 JSON 到 Model 的转换。
library;

import '../models/person.dart';
import 'base_repository.dart';
import 'interfaces/person_repository.dart';

class PersonRepository extends BaseRepository implements IPersonRepository {
  PersonRepository(super.dbService);

  @override
  Future<Person?> getDefaultPerson() async {
    final db = await dbService.database;
    final results = await db.query(
      'persons',
      where: 'is_default = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _fromRow(results.first);
  }

  @override
  Future<Person?> getPerson(String id) async {
    final db = await dbService.database;
    final results = await db.query(
      'persons',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _fromRow(results.first);
  }

  Person _fromRow(Map<String, dynamic> row) {
    // 数据库中的 created_at_ms 是 int，需要转换为 DateTime
    final json = Map<String, dynamic>.from(row);
    if (json['created_at_ms'] != null) {
      json['createdAt'] = DateTime.fromMillisecondsSinceEpoch(
        json['created_at_ms'] as int,
      ).toIso8601String();
    }
    // is_default (0/1) to boolean
    json['isDefault'] = (json['is_default'] as int) == 1;

    // Database keys to Model keys
    // Model expects lowerCamelCase
    if (json['avatar_path'] != null) {
      json['avatarPath'] = json['avatar_path'];
    }

    return Person.fromJson(json);
  }
}
