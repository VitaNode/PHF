import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:phf/data/datasources/local/database_service.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/data/models/image.dart';
import 'package:phf/data/repositories/record_repository.dart';
import 'package:phf/data/repositories/image_repository.dart';
import 'dart:convert';

@GenerateNiceMocks([MockSpec<SQLCipherDatabaseService>()])
import 'repository_test.mocks.dart';

void main() {
  // Initialize FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late RecordRepository recordRepo;
  late ImageRepository imageRepo;
  late MockSQLCipherDatabaseService mockDbService;
  late Database db;

  setUp(() async {
    mockDbService = MockSQLCipherDatabaseService();

    // Create an in-memory database for testing
    // We manually replicate _onCreate logic since we can't easily invoke the real private _onCreate
    // from the service without full setup.
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    // Enable Foreign Keys
    await db.execute('PRAGMA foreign_keys = ON');

    // Create Tables (simplified schema sufficient for repository testing)
    await db.execute(
      'CREATE TABLE persons (id TEXT PRIMARY KEY, nickname TEXT, avatar_path TEXT, is_default INTEGER, created_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE TABLE records (id TEXT PRIMARY KEY, person_id TEXT, status TEXT, visit_date_ms INTEGER, visit_date_iso TEXT, hospital_name TEXT, notes TEXT, tags_cache TEXT, visit_end_date_ms INTEGER, created_at_ms INTEGER, updated_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE TABLE images (id TEXT PRIMARY KEY, record_id TEXT, file_path TEXT, thumbnail_path TEXT, encryption_key TEXT, thumbnail_encryption_key TEXT, width INTEGER, height INTEGER, hospital_name TEXT, visit_date_ms INTEGER, mime_type TEXT, file_size INTEGER, page_index INTEGER, ocr_text TEXT, ocr_raw_json TEXT, ocr_confidence REAL, tags TEXT, created_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE TABLE tags (id TEXT PRIMARY KEY, name TEXT UNIQUE, color TEXT, order_index INTEGER, person_id TEXT, is_custom INTEGER, created_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE TABLE image_tags (image_id TEXT REFERENCES images(id) ON DELETE CASCADE, tag_id TEXT REFERENCES tags(id) ON DELETE CASCADE, PRIMARY KEY (image_id, tag_id))',
    );
    await db.execute(
      'CREATE TABLE ocr_queue (id TEXT PRIMARY KEY, image_id TEXT REFERENCES images(id) ON DELETE CASCADE, status TEXT, retry_count INTEGER, last_error TEXT, created_at_ms INTEGER, updated_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE VIRTUAL TABLE ocr_search_index USING fts5(record_id UNINDEXED, person_id UNINDEXED, hospital_name, tags, ocr_text, notes, content)',
    );

    // Basic Data
    await db.execute(
      "INSERT INTO persons (id, nickname, created_at_ms) VALUES ('p1', 'Tester', 12345)",
    );
    await db.execute(
      "INSERT INTO persons (id, nickname, created_at_ms) VALUES ('p2', 'Other User', 12345)",
    );
    await db.execute(
      "INSERT INTO tags (id, name, created_at_ms) VALUES ('t1', 'Blood', 12345)",
    );
    await db.execute(
      "INSERT INTO tags (id, name, created_at_ms) VALUES ('t2', 'XRay', 12345)",
    );

    // Wire up mock to return our in-memory DB
    when(mockDbService.database).thenAnswer((_) async => db);

    recordRepo = RecordRepository(mockDbService);
    imageRepo = ImageRepository(mockDbService);
  });

  tearDown(() async {
    await db.close();
  });

  group('RecordRepository Security Tests', () {
    test('getRecords with query should isolate by person_id', () async {
      // 1. Seed records for two users
      await db.insert('records', {
        'id': 'r1',
        'person_id': 'p1',
        'status': 'archived',
        'created_at_ms': 0,
        'updated_at_ms': 0,
      });
      await db.insert('ocr_search_index', {
        'record_id': 'r1',
        'person_id': 'p1',
        'content': 'Secret data for p1',
      });

      await db.insert('records', {
        'id': 'r2',
        'person_id': 'p2',
        'status': 'archived',
        'created_at_ms': 0,
        'updated_at_ms': 0,
      });
      await db.insert('ocr_search_index', {
        'record_id': 'r2',
        'person_id': 'p2',
        'content': 'Secret data for p2',
      });

      // 2. User 1 searches for their own data
      final results1 = await recordRepo.searchRecords(
        personId: 'p1',
        query: 'Secret',
      );
      expect(results1.length, 1);
      expect(results1.first.id, 'r1');

      // 3. User 1 searches for User 2's data (keyword is same, but person_id differs)
      // Even if keyword matches, it should only return r1 because of person_id filter
      final results1Overlap = await recordRepo.searchRecords(
        personId: 'p1',
        query: 'data',
      );
      expect(results1Overlap.length, 1);
      expect(results1Overlap.first.id, 'r1');

      // 4. User 2 searches for their own data
      final results2 = await recordRepo.searchRecords(
        personId: 'p2',
        query: 'Secret',
      );
      expect(results2.length, 1);
      expect(results2.first.id, 'r2');
    });
  });

  group('RecordRepository Tests', () {
    test('saveRecord and getRecordById', () async {
      final record = MedicalRecord(
        id: 'r1',
        personId: 'p1',
        hospitalName: 'General Hospital',
        notedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await recordRepo.saveRecord(record);

      final fetched = await recordRepo.getRecordById('r1');
      expect(fetched, isNotNull);
      expect(fetched!.hospitalName, 'General Hospital');
      expect(fetched.images, isEmpty);
    });
  });

  group('ImageRepository & Sync', () {
    test('Syncs tags_cache to record when image tags update', () async {
      // 1. Setup Record
      final record = MedicalRecord(
        id: 'r1',
        personId: 'p1',
        notedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await recordRepo.saveRecord(record);

      // 2. Setup Image
      final image = MedicalImage(
        id: 'i1',
        recordId: 'r1',
        encryptionKey: 'key',
        thumbnailEncryptionKey: 'thumb_key',
        filePath: 'path',
        thumbnailPath: 'thumb',
        createdAt: DateTime.now(),
      );
      await imageRepo.saveImages([image]);

      // 3. Update Image Tags -> Trigger Sync
      // Associate 't1' (Blood) and 't2' (XRay) with 'i1'
      // This should update record (r1)'s tags_cache
      await imageRepo.updateImageTags('i1', ['t1', 't2']);

      // 4. Verify Record tags_cache
      final fetchedRecord = await recordRepo.getRecordById('r1');
      expect(fetchedRecord?.tagsCache, isNotNull);

      final List<dynamic> tags =
          jsonDecode(fetchedRecord!.tagsCache!) as List<dynamic>;
      expect(tags, containsAll(['Blood', 'XRay']));
    });

    test('deleteImage triggers sync (removes tags)', () async {
      // Setup: Record with Image with Tags
      await db.insert('records', {
        'id': 'r2',
        'person_id': 'p1',
        'status': 'archived',
        'visit_date_ms': 12345,
        'created_at_ms': 1,
        'updated_at_ms': 1,
      });
      await db.insert('images', {
        'id': 'i2',
        'record_id': 'r2',
        'file_path': 'p',
        'thumbnail_path': 't',
        'encryption_key': 'k',
        'thumbnail_encryption_key': 'tk',
        'created_at_ms': 1,
      });
      // Add another image so the record isn't deleted when i2 is removed
      await db.insert('images', {
        'id': 'i2_placeholder',
        'record_id': 'r2',
        'file_path': 'p2',
        'thumbnail_path': 't2',
        'encryption_key': 'k2',
        'thumbnail_encryption_key': 'tk2',
        'created_at_ms': 2,
      });
      await db.insert('image_tags', {'image_id': 'i2', 'tag_id': 't1'});

      // Pre-sync manually or assume state
      await db.update(
        'records',
        {'tags_cache': '["Blood"]'},
        where: 'id = ?',
        whereArgs: ['r2'],
      );

      // Action: Delete Image
      await imageRepo.deleteImage('i2');

      // Verify: Image i2 is gone
      final imageCheck = await db.query(
        'images',
        where: 'id = ?',
        whereArgs: ['i2'],
      );
      expect(imageCheck, isEmpty);

      // Verify: Record tags_cache cleared (since the only image with tags was deleted)
      final fetchedRecord = await recordRepo.getRecordById('r2');
      final List<dynamic> tags =
          jsonDecode(fetchedRecord!.tagsCache!) as List<dynamic>;
      expect(tags, isEmpty);
    });

    test(
      'Deleting the last image of a record deletes the Record entity and OCR tasks',
      () async {
        // 1. Setup Record with 1 Image and OCR data
        await db.insert('records', {
          'id': 'r3',
          'person_id': 'p1',
          'status': 'archived',
          'visit_date_ms': 12345,
          'created_at_ms': 1,
          'updated_at_ms': 1,
        });
        await db.insert('images', {
          'id': 'i3',
          'record_id': 'r3',
          'file_path': 'p',
          'thumbnail_path': 't',
          'encryption_key': 'k',
          'thumbnail_encryption_key': 'tk',
          'created_at_ms': 1,
        });
        await db.insert('ocr_queue', {
          'id': 'q1',
          'image_id': 'i3',
          'status': 'pending',
          'created_at_ms': 1,
          'updated_at_ms': 1,
        });
        await db.insert('ocr_search_index', {
          'record_id': 'r3',
          'person_id': 'p1',
          'content': 'Hospital report content',
        });

        // 2. Action: Delete the only image
        await imageRepo.deleteImage('i3');

        // 3. Verify: Image is gone
        final imageCheck = await db.query(
          'images',
          where: 'id = ?',
          whereArgs: ['i3'],
        );
        expect(imageCheck, isEmpty);

        // 4. Verify: Record is gone (Cascaded/Manual cleanup)
        final recordCheck = await db.query(
          'records',
          where: 'id = ?',
          whereArgs: ['r3'],
        );
        expect(recordCheck, isEmpty);

        // 5. Verify: OCR Queue is gone
        final queueCheck = await db.query(
          'ocr_queue',
          where: 'image_id = ?',
          whereArgs: ['i3'],
        );
        expect(queueCheck, isEmpty);

        // 6. Verify: Search Index is gone
        final searchCheck = await db.query(
          'ocr_search_index',
          where: 'record_id = ?',
          whereArgs: ['r3'],
        );
        expect(searchCheck, isEmpty);
      },
    );
  });
}
