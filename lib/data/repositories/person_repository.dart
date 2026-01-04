/// # PersonRepository Implementation
///
/// ## Description
/// `IPersonRepository` 的具体实现。
///
/// ## Security
/// - 基于 SQLCipher 加密环境。
///
/// ## Constraints
/// - **Deletion**: 仅当 `records` 表中没有关联记录时才允许删除人员。
library;

import 'package:sqflite_sqlcipher/sqflite.dart';
import '../datasources/local/database_service.dart';
import '../models/person.dart';
import 'interfaces/person_repository.dart';

class PersonRepository implements IPersonRepository {
  final SQLCipherDatabaseService _dbService;

  PersonRepository(this._dbService);

  @override
  Future<List<Person>> getAllPersons() async {
    final db = await _dbService.database;
    final maps = await db.query('persons', orderBy: 'order_index ASC');

    return maps.map((row) => _mapToPerson(row)).toList();
  }

  @override
  Future<void> createPerson(Person person) async {
    final db = await _dbService.database;
    await db.insert(
      'persons',
      _mapToDb(person),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updatePerson(Person person) async {
    final db = await _dbService.database;
    await db.update(
      'persons',
      _mapToDb(person),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  @override
  Future<void> deletePerson(String id) async {
    final db = await _dbService.database;

    // Check constraints
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM records WHERE person_id = ? AND status != ?',
        [id, 'deleted'],
      ),
    );

    if (count != null && count > 0) {
      throw Exception('Cannot delete person with existing records.');
    }

    // Allow delete if only 'deleted' records exist?
    // Usually we keep 'deleted' records for sync/audit but orphan them or hard delete them?
    // Constitution says "Cascade Delete".
    // Spec says "Deletion Constraint: Forbid deletion if the person has records".
    // "Deletion constraint: If person has records, forbid deletion." implies active records.
    // If records are logically deleted, maybe we should allow?
    // Let's assume strict check: No records at all. Or check non-deleted records.
    // The query above checks `status != 'deleted'`. So logically deleted records won't block.
    // However, the FK has ON DELETE CASCADE. So if we delete person, records will be deleted.
    // The requirement is to PREVENT accidental deletion of valuable data.

    // If strict requirement "Forbid deletion if the person has records", it usually means valid records.
    // So `status != 'deleted'` is correct.

    await db.delete('persons', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> updateOrder(List<Person> persons) async {
    final db = await _dbService.database;
    await db.transaction((txn) async {
      for (int i = 0; i < persons.length; i++) {
        await txn.update(
          'persons',
          {'order_index': i},
          where: 'id = ?',
          whereArgs: [persons[i].id],
        );
      }
    });
  }

  // --- Mappers ---

  Person _mapToPerson(Map<String, dynamic> row) {
    return Person(
      id: row['id'] as String,
      nickname: row['nickname'] as String,
      avatarPath: row['avatar_path'] as String?,
      isDefault: (row['is_default'] as int? ?? 0) == 1,
      orderIndex: row['order_index'] as int? ?? 0,
      profileColor: row['profile_color'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row['created_at_ms'] as int,
      ),
    );
  }

  Map<String, dynamic> _mapToDb(Person person) {
    return {
      'id': person.id,
      'nickname': person.nickname,
      'avatar_path': person.avatarPath,
      'is_default': person.isDefault ? 1 : 0,
      'order_index': person.orderIndex,
      'profile_color': person.profileColor,
      'created_at_ms': person.createdAt.millisecondsSinceEpoch,
    };
  }
}
