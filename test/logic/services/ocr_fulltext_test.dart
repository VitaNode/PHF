import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:phf/data/datasources/local/database_service.dart';
import 'package:phf/data/models/ocr_result.dart';
import 'package:phf/data/repositories/record_repository.dart';
import 'package:phf/data/repositories/image_repository.dart';
import 'package:phf/data/repositories/search_repository.dart';
import 'package:phf/data/repositories/ocr_queue_repository.dart';
import 'package:phf/logic/services/ocr_processor.dart';
import 'package:phf/logic/services/interfaces/ocr_service.dart';
import 'package:phf/core/security/file_security_helper.dart';
import 'package:phf/core/services/path_provider_service.dart';
import 'dart:typed_data';

import 'ocr_fulltext_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SQLCipherDatabaseService>(),
  MockSpec<IOCRService>(),
  MockSpec<FileSecurityHelper>(),
  MockSpec<PathProviderService>(),
])
void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Database db;
  late MockSQLCipherDatabaseService mockDbService;
  late MockIOCRService mockOcrService;
  late MockFileSecurityHelper mockSecurityHelper;
  late MockPathProviderService mockPathService;

  late RecordRepository recordRepo;
  late ImageRepository imageRepo;
  late SearchRepository searchRepo;
  late OCRQueueRepository queueRepo;
  late OCRProcessor processor;

  setUp(() async {
    mockDbService = MockSQLCipherDatabaseService();
    mockOcrService = MockIOCRService();
    mockSecurityHelper = MockFileSecurityHelper();
    mockPathService = MockPathProviderService();

    db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await db.execute('PRAGMA foreign_keys = ON');

    // Minimal Schema (v8)
    await db.execute(
      'CREATE TABLE persons (id TEXT PRIMARY KEY, nickname TEXT, avatar_path TEXT, is_default INTEGER, created_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE TABLE records (id TEXT PRIMARY KEY, person_id TEXT, status TEXT, is_verified INTEGER DEFAULT 0, group_id TEXT, visit_date_ms INTEGER, visit_date_iso TEXT, hospital_name TEXT, notes TEXT, tags_cache TEXT, visit_end_date_ms INTEGER, created_at_ms INTEGER, updated_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE TABLE images (id TEXT PRIMARY KEY, record_id TEXT, file_path TEXT, thumbnail_path TEXT, encryption_key TEXT, thumbnail_encryption_key TEXT, width INTEGER, height INTEGER, hospital_name TEXT, visit_date_ms INTEGER, mime_type TEXT, file_size INTEGER, page_index INTEGER, ocr_text TEXT, ocr_raw_json TEXT, ocr_confidence REAL, tags TEXT, created_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE TABLE ocr_queue (id TEXT PRIMARY KEY, image_id TEXT REFERENCES images(id) ON DELETE CASCADE, status TEXT, retry_count INTEGER, last_error TEXT, created_at_ms INTEGER, updated_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE VIRTUAL TABLE ocr_search_index USING fts5(record_id UNINDEXED, person_id UNINDEXED, hospital_name, tags, ocr_text, notes, content)',
    );

    when(mockDbService.database).thenAnswer((_) async => db);
    when(mockPathService.sandboxRoot).thenReturn('/sandbox');

    recordRepo = RecordRepository(mockDbService);
    imageRepo = ImageRepository(mockDbService);
    searchRepo = SearchRepository(mockDbService);
    queueRepo = OCRQueueRepository(mockDbService);
    processor = OCRProcessor(
      queueRepository: queueRepo,
      imageRepository: imageRepo,
      recordRepository: recordRepo,
      searchRepository: searchRepo,
      ocrService: mockOcrService,
      securityHelper: mockSecurityHelper,
      pathService: mockPathService,
      dbService: mockDbService,
    );

    // Initial Data
    await db.execute(
      "INSERT INTO persons (id, nickname, created_at_ms) VALUES ('p1', 'User 1', 0)",
    );
    await db.execute(
      "INSERT INTO persons (id, nickname, created_at_ms) VALUES ('p2', 'User 2', 0)",
    );

    // Record for p1
    await db.insert('records', {
      'id': 'r1',
      'person_id': 'p1',
      'status': 'processing',
      'created_at_ms': 0,
      'updated_at_ms': 0,
    });
    await db.insert('images', {
      'id': 'i1',
      'record_id': 'r1',
      'file_path': 'f1',
      'thumbnail_path': 't1',
      'encryption_key': 'k1',
      'thumbnail_encryption_key': 'tk1',
      'created_at_ms': 0,
    });

    // Record for p2
    await db.insert('records', {
      'id': 'r2',
      'person_id': 'p2',
      'status': 'processing',
      'created_at_ms': 10,
      'updated_at_ms': 10,
    });
    await db.insert('images', {
      'id': 'i2',
      'record_id': 'r2',
      'file_path': 'f2',
      'thumbnail_path': 't2',
      'encryption_key': 'k2',
      'thumbnail_encryption_key': 'tk2',
      'created_at_ms': 10,
    });

    await db.insert('ocr_queue', {
      'id': 'q1',
      'image_id': 'i1',
      'status': 'pending',
      'retry_count': 0,
      'created_at_ms': 0,
      'updated_at_ms': 0,
    });
    await db.insert('ocr_queue', {
      'id': 'q2',
      'image_id': 'i2',
      'status': 'pending',
      'retry_count': 0,
      'created_at_ms': 10,
      'updated_at_ms': 10,
    });
  });

  tearDown(() async {
    await db.close();
  });

  test('Search index should isolate results by person_id', () async {
    // 1. Process p1's image
    when(
      mockSecurityHelper.decryptDataFromFile(any, any),
    ).thenAnswer((_) async => Uint8List(0));
    when(
      mockOcrService.recognizeText(any, mimeType: anyNamed('mimeType')),
    ).thenAnswer(
      (_) async =>
          const OcrResult(text: 'Secret content for P1', confidence: 0.95),
    );

    await processor.processNextItem();

    // 2. Process p2's image
    when(
      mockOcrService.recognizeText(any, mimeType: anyNamed('mimeType')),
    ).thenAnswer(
      (_) async =>
          const OcrResult(text: 'Public content for P2', confidence: 0.95),
    );

    await processor.processNextItem();

    // 3. P1 searches for their own content
    var results = await searchRepo.search('Secret', 'p1');
    expect(results.length, 1);
    expect(results.first.record.personId, 'p1');

    // 4. P2 searches for P1's content -> Should be EMPTY
    results = await searchRepo.search('Secret', 'p2');
    expect(results, isEmpty, reason: 'P2 should not find P1 content');

    // 5. P2 searches for their own content
    results = await searchRepo.search('Public', 'p2');
    expect(results.length, 1);
    expect(results.first.record.personId, 'p2');
  });

  test(
    'RecordRepository.searchRecords should also isolate results by person_id',
    () async {
      // 1. Manually insert data into FTS index (as if OCR happened)
      await db.insert('ocr_search_index', {
        'record_id': 'r1',
        'person_id': 'p1',
        'content': 'Secret P1',
      });
      await db.insert('ocr_search_index', {
        'record_id': 'r2',
        'person_id': 'p2',
        'content': 'Public P2',
      });

      // 2. P2 searches for 'Secret' through RecordRepository
      // This uses FTS JOIN
      final results = await recordRepo.searchRecords(
        personId: 'p2',
        query: 'Secret',
      );

      expect(
        results,
        isEmpty,
        reason: 'P2 should not find P1 content even if joined with FTS',
      );
    },
  );

  test('RecordRepository.searchRecords should support CJK search', () async {
    // 1. Manually insert segmented CJK into FTS index
    await db.insert('ocr_search_index', {
      'record_id': 'r1',
      'person_id': 'p1',
      'content': ' 结 果 ', // Segmented '结果'
    });

    // 2. Search for '结果' (unsegmented)
    final results = await recordRepo.searchRecords(personId: 'p1', query: '结果');

    expect(results.length, 1, reason: 'Should find segmented CJK content');
  });
}
