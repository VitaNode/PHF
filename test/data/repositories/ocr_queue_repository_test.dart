import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:phf/data/datasources/local/database_service.dart';
import 'package:phf/data/models/ocr_queue_item.dart';
import 'package:phf/data/repositories/ocr_queue_repository.dart';

@GenerateNiceMocks([MockSpec<SQLCipherDatabaseService>()])
import 'ocr_queue_repository_test.mocks.dart';

void main() {
  // Initialize FFI for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late OCRQueueRepository queueRepo;
  late MockSQLCipherDatabaseService mockDbService;
  late Database db;

  setUp(() async {
    mockDbService = MockSQLCipherDatabaseService();

    // Create an in-memory database
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    
    // Create Table
    await db.execute('''
      CREATE TABLE ocr_queue (
        id              TEXT PRIMARY KEY,
        image_id        TEXT NOT NULL,
        status          TEXT NOT NULL DEFAULT 'pending',
        retry_count     INTEGER DEFAULT 0,
        last_error      TEXT,
        created_at_ms   INTEGER NOT NULL,
        updated_at_ms   INTEGER NOT NULL
      )
    ''');
    // Index for queue (optional for functional test but good practice)
    await db.execute('CREATE INDEX idx_ocr_queue_status ON ocr_queue(status)');

    when(mockDbService.database).thenAnswer((_) async => db);

    queueRepo = OCRQueueRepository(mockDbService);
  });

  tearDown(() async {
    await db.close();
  });

  group('OCRQueueRepository', () {
    test('enqueue adds item with pending status', () async {
      await queueRepo.enqueue('img_1');
      
      final count = await queueRepo.getPendingCount();
      expect(count, 1);
      
      final item = await queueRepo.dequeue();
      expect(item, isNotNull);
      expect(item!.imageId, 'img_1');
      expect(item.status, OCRJobStatus.pending);
      expect(item.retryCount, 0);
    });

    test('dequeue returns oldest pending item (FIFO)', () async {
      // Insert in order
      await queueRepo.enqueue('img_1');
      await Future.delayed(const Duration(milliseconds: 10)); // Ensure timestamp diff
      await queueRepo.enqueue('img_2');

      final first = await queueRepo.dequeue();
      expect(first!.imageId, 'img_1');
      
      // Simulate processing first
      await queueRepo.updateStatus(first.id, OCRJobStatus.completed);

      final second = await queueRepo.dequeue();
      expect(second!.imageId, 'img_2');
    });

    test('dequeue returns null when no pending items', () async {
      final item = await queueRepo.dequeue();
      expect(item, isNull);
    });

    test('updateStatus changes status and last_error', () async {
      await queueRepo.enqueue('img_1');
      var item = await queueRepo.dequeue();
      
      await queueRepo.updateStatus(item!.id, OCRJobStatus.failed, error: 'Network Error');
      
      // Verify in DB directly or via logic
      // Since dequeue only returns pending, we can't fetch it via dequeue anymore.
      // We can query DB directly to verify.
      final result = await db.query('ocr_queue', where: 'id = ?', whereArgs: [item.id]);
      expect(result.first['status'], OCRJobStatus.failed.name);
      expect(result.first['last_error'], 'Network Error');
    });

    test('incrementRetry increases count and updates timestamp', () async {
      await queueRepo.enqueue('img_1');
      var item = await queueRepo.dequeue();
      
      final before = DateTime.now();
      await Future.delayed(const Duration(milliseconds: 10));
      
      await queueRepo.incrementRetry(item!.id);
      
      final result = await db.query('ocr_queue', where: 'id = ?', whereArgs: [item.id]);
      expect(result.first['retry_count'], 1);
      expect((result.first['updated_at_ms'] as int) > before.millisecondsSinceEpoch, isTrue);
    });

    test('deleteJob removes item', () async {
      await queueRepo.enqueue('img_1');
      var item = await queueRepo.dequeue();
      
      await queueRepo.deleteJob(item!.id);
      
      final count = await queueRepo.getPendingCount(); // Should be 0 if we deleted it. 
      // Wait, dequeue doesn't remove it, just reads it.
      // If we delete it, getPendingCount should be 0.
      expect(count, 0);
    });
  });
}
