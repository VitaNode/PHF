/// # OCRQueueRepository Implementation
///
/// ## Description
/// `IOCRQueueRepository` 的具体实现。
///
/// ## Security
/// - 所有操作在 SQL 事务架构下进行，确保队列一致性。
///
/// ## Fix Record
/// - **2025-12-31**: 修复了缺少 `sqflite` 包引用导致的编译错误 (Undefined name 'Sqflite')。
library;

import 'package:uuid/uuid.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../models/ocr_queue_item.dart';
import 'base_repository.dart';
import 'interfaces/ocr_queue_repository.dart';

class OCRQueueRepository extends BaseRepository implements IOCRQueueRepository {
  OCRQueueRepository(super.dbService);

  @override
  Future<void> enqueue(String imageId) async {
    final db = await dbService.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      // Check if a job already exists for this image
      final existing = await txn.query(
        'ocr_queue',
        where: 'image_id = ?',
        whereArgs: [imageId],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        // Reset existing job to pending
        await txn.update(
          'ocr_queue',
          {
            'status': OCRJobStatus.pending.name,
            'retry_count': 0,
            'last_error': null,
            'updated_at_ms': now,
          },
          where: 'image_id = ?',
          whereArgs: [imageId],
        );
      } else {
        // Create new job
        await txn.insert('ocr_queue', {
          'id': const Uuid().v4(),
          'image_id': imageId,
          'status': OCRJobStatus.pending.name,
          'retry_count': 0,
          'created_at_ms': now,
          'updated_at_ms': now,
        });
      }
    });
  }

  @override
  Future<OCRQueueItem?> dequeue() async {
    final db = await dbService.database;

    // 获取一个 pending 状态的任务
    final maps = await db.query(
      'ocr_queue',
      where: 'status = ?',
      whereArgs: [OCRJobStatus.pending.name],
      orderBy: 'created_at_ms ASC',
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final row = maps.first;
    return OCRQueueItem(
      id: row['id'] as String,
      imageId: row['image_id'] as String,
      status: OCRJobStatus.values.firstWhere((e) => e.name == row['status']),
      retryCount: row['retry_count'] as int,
      lastError: row['last_error'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row['created_at_ms'] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row['updated_at_ms'] as int,
      ),
    );
  }

  @override
  Future<void> updateStatus(
    String id,
    OCRJobStatus status, {
    String? error,
  }) async {
    final db = await dbService.database;
    await db.update(
      'ocr_queue',
      {
        'status': status.name,
        'last_error': error,
        'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> incrementRetry(String id) async {
    final db = await dbService.database;
    await db.execute(
      'UPDATE ocr_queue SET retry_count = retry_count + 1, updated_at_ms = ? WHERE id = ?',
      [DateTime.now().millisecondsSinceEpoch, id],
    );
  }

  @override
  Future<int> getPendingCount({String? personId}) async {
    final db = await dbService.database;

    if (personId == null) {
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM ocr_queue WHERE status = ?', [
          OCRJobStatus.pending.name,
        ]),
      );
      return count ?? 0;
    } else {
      final count = Sqflite.firstIntValue(
        await db.rawQuery(
          '''
          SELECT COUNT(*) 
          FROM ocr_queue q
          JOIN images i ON q.image_id = i.id
          JOIN records r ON i.record_id = r.id
          WHERE q.status = ? AND r.person_id = ?
          ''',
          [OCRJobStatus.pending.name, personId],
        ),
      );
      return count ?? 0;
    }
  }

  @override
  Future<void> deleteJob(String id) async {
    final db = await dbService.database;
    await db.delete('ocr_queue', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> deleteByImageId(String imageId) async {
    final db = await dbService.database;
    await db.delete('ocr_queue', where: 'image_id = ?', whereArgs: [imageId]);
  }
}
