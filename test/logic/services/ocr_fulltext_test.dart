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

    // Minimal Schema
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
      'CREATE TABLE ocr_queue (id TEXT PRIMARY KEY, image_id TEXT REFERENCES images(id) ON DELETE CASCADE, status TEXT, retry_count INTEGER, last_error TEXT, created_at_ms INTEGER, updated_at_ms INTEGER)',
    );
    await db.execute(
      'CREATE VIRTUAL TABLE ocr_search_index USING fts5(record_id UNINDEXED, hospital_name, tags, ocr_text, notes, content)',
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
    );

    // Initial Data
    await db.execute(
      "INSERT INTO persons (id, nickname, created_at_ms) VALUES ('p1', 'User', 0)",
    );
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
    await db.insert('images', {
      'id': 'i2',
      'record_id': 'r1',
      'file_path': 'f2',
      'thumbnail_path': 't2',
      'encryption_key': 'k2',
      'thumbnail_encryption_key': 'tk2',
      'created_at_ms': 1,
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
      'created_at_ms': 1,
      'updated_at_ms': 1,
    });
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'Search index should aggregate text from multiple images in the same record',
    () async {
      // 1. Process Image 1
      when(
        mockSecurityHelper.decryptDataFromFile(any, any),
      ).thenAnswer((_) async => Uint8List(0));
      when(
        mockOcrService.recognizeText(any, mimeType: anyNamed('mimeType')),
      ).thenAnswer(
        (_) async => const OCRResult(text: 'Alpha content', confidence: 0.95),
      );

      await processor.processNextItem();

      // Verify searchable by Image 1 text
      var results = await searchRepo.search('Alpha', 'p1');
      expect(results.length, 1);
      expect(results.first.record.id, 'r1');

      // 2. Process Image 2
      when(
        mockOcrService.recognizeText(any, mimeType: anyNamed('mimeType')),
      ).thenAnswer(
        (_) async => const OCRResult(text: 'Beta keyword', confidence: 0.95),
      );

      await processor.processNextItem();

      // Verify searchable by Image 2 text
      results = await searchRepo.search('Beta', 'p1');
      expect(results.length, 1, reason: 'Should find record by Image 2 text');

      // Verify searchable by Image 1 text (THIS IS WHERE IT CURRENTLY FAILS if overwriting)
      results = await searchRepo.search('Alpha', 'p1');
      expect(
        results.length,
        1,
        reason:
            'Should STILL find record by Image 1 text after Image 2 processed',
      );
    },
  );
}
