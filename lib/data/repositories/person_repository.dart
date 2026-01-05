/// # PersonRepository Implementation
///
/// ## Description
/// `IPersonRepository` 的具体实现。
///
/// ## Repair Logs
/// - [2026-01-05] 修复：
///   1. 注入 `Talker` 实例进行日志记录，增强可观测性。
///   2. 为所有异步操作添加 try-catch 块，确保异常被捕获并记录，符合健壮性要求。
///   3. 优化错误处理，确保在删除受限人员时记录详细日志。
///
/// ## Security
/// - 基于 SQLCipher 加密环境。
///
/// ## Constraints
/// - **Deletion**: 仅当 `records` 表中没有关联记录时才允许删除人员。
library;

import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../datasources/local/database_service.dart';
import '../models/person.dart';
import 'interfaces/person_repository.dart';

class PersonRepository implements IPersonRepository {
  final SQLCipherDatabaseService _dbService;
  final Talker _talker;

  PersonRepository(this._dbService, this._talker);

  @override
  Future<List<Person>> getAllPersons() async {
    try {
      final db = await _dbService.database;
      final maps = await db.query('persons', orderBy: 'order_index ASC');

      return maps.map((row) => _mapToPerson(row)).toList();
    } catch (e, st) {
      _talker.handle(e, st, 'PersonRepository.getAllPersons');
      rethrow;
    }
  }

  @override
  Future<Person?> getDefaultPerson() async {
    try {
      final db = await _dbService.database;
      final results = await db.query(
        'persons',
        where: 'is_default = ?',
        whereArgs: [1],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return _mapToPerson(results.first);
    } catch (e, st) {
      _talker.handle(e, st, 'PersonRepository.getDefaultPerson');
      rethrow;
    }
  }

  @override
  Future<Person?> getPerson(String id) async {
    try {
      final db = await _dbService.database;
      final results = await db.query(
        'persons',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return _mapToPerson(results.first);
    } catch (e, st) {
      _talker.handle(e, st, 'PersonRepository.getPerson');
      rethrow;
    }
  }

  @override
  Future<void> createPerson(Person person) async {
    try {
      final db = await _dbService.database;
      await db.insert(
        'persons',
        _mapToDb(person),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e, st) {
      _talker.handle(e, st, 'PersonRepository.createPerson');
      rethrow;
    }
  }

  @override
  Future<void> updatePerson(Person person) async {
    try {
      final db = await _dbService.database;
      await db.update(
        'persons',
        _mapToDb(person),
        where: 'id = ?',
        whereArgs: [person.id],
      );
    } catch (e, st) {
      _talker.handle(e, st, 'PersonRepository.updatePerson');
      rethrow;
    }
  }

  @override
  Future<void> deletePerson(String id) async {
    try {
      final db = await _dbService.database;

      // Check constraints
      final count = Sqflite.firstIntValue(
        await db.rawQuery(
          'SELECT COUNT(*) FROM records WHERE person_id = ? AND status != ?',
          [id, 'deleted'],
        ),
      );

      if (count != null && count > 0) {
        final err = Exception('无法删除：该档案下仍有存量记录，请先清理记录。');
        _talker.error(
          'PersonRepository.deletePerson: constraint violation for id=$id',
          err,
        );
        throw err;
      }

      await db.delete('persons', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      if (e is! Exception) {
        _talker.handle(e, st, 'PersonRepository.deletePerson');
      }
      rethrow;
    }
  }

  @override
  Future<void> updateOrder(List<Person> persons) async {
    try {
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
    } catch (e, st) {
      _talker.handle(e, st, 'PersonRepository.updateOrder');
      rethrow;
    }
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
