import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/core/security/file_security_helper.dart';
import 'package:phf/data/models/image.dart';
import 'package:phf/data/models/ocr_queue_item.dart';
import 'package:phf/data/models/ocr_result.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/data/repositories/interfaces/image_repository.dart';
import 'package:phf/data/repositories/interfaces/ocr_queue_repository.dart';
import 'package:phf/data/repositories/interfaces/record_repository.dart';
import 'package:phf/data/repositories/interfaces/search_repository.dart';
import 'package:phf/core/services/path_provider_service.dart';
import 'package:phf/logic/services/interfaces/ocr_service.dart';
import 'package:phf/logic/services/ocr_processor.dart';

import 'ocr_processor_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<IOCRQueueRepository>(),
  MockSpec<IImageRepository>(),
  MockSpec<IRecordRepository>(),
  MockSpec<ISearchRepository>(),
  MockSpec<IOCRService>(),
  MockSpec<FileSecurityHelper>(),
  MockSpec<PathProviderService>(),
])
void main() {
  late MockIOCRQueueRepository mockQueueRepo;
  late MockIImageRepository mockImageRepo;
  late MockIRecordRepository mockRecordRepo;
  late MockISearchRepository mockSearchRepo;
  late MockIOCRService mockOcrService;
  late MockFileSecurityHelper mockSecurityHelper;
  late MockPathProviderService mockPathService;
  late OCRProcessor processor;

  setUp(() {
    mockQueueRepo = MockIOCRQueueRepository();
    mockImageRepo = MockIImageRepository();
    mockRecordRepo = MockIRecordRepository();
    mockSearchRepo = MockISearchRepository();
    mockOcrService = MockIOCRService();
    mockSecurityHelper = MockFileSecurityHelper();
    mockPathService = MockPathProviderService();

    processor = OCRProcessor(
      queueRepository: mockQueueRepo,
      imageRepository: mockImageRepo,
      recordRepository: mockRecordRepo,
      searchRepository: mockSearchRepo,
      ocrService: mockOcrService,
      securityHelper: mockSecurityHelper,
      pathService: mockPathService,
    );
  });

  group('OCRProcessor', () {
    test('processNextItem returns false when queue is empty', () async {
      when(mockQueueRepo.dequeue()).thenAnswer((_) async => null);

      final result = await processor.processNextItem();

      expect(result, isFalse);
      verifyNever(mockImageRepo.getImageById(any));
    });

    test('Full success flow (High Confidence)', () async {
      final item = OCRQueueItem(
          id: '1', imageId: 'img1', status: OCRJobStatus.pending, 
          createdAt: DateTime.now(), updatedAt: DateTime.now());
      final image = MedicalImage(
        id: 'img1', recordId: 'rec1', filePath: '/path', encryptionKey: 'key', 
        thumbnailEncryptionKey: 'key_thumb', thumbnailPath: '/path_thumb', mimeType: 'image/jpeg',
        createdAt: DateTime.now()
      );
      final record = MedicalRecord(
        id: 'rec1', personId: 'p1', notedAt: DateTime.now(), 
        createdAt: DateTime.now(), updatedAt: DateTime.now(),
        status: RecordStatus.processing
      );
      final decryptedBytes = Uint8List(10);
      const ocrResult = OCRResult(text: '2023-10-10\nHospital A', confidence: 0.95);

      when(mockQueueRepo.dequeue()).thenAnswer((_) async => item);
      when(mockImageRepo.getImageById('img1')).thenAnswer((_) async => image);
      when(mockSecurityHelper.decryptDataFromFile(any, any)).thenAnswer((_) async => decryptedBytes);
      when(mockOcrService.recognizeText(any, mimeType: anyNamed('mimeType'))).thenAnswer((_) async => ocrResult);
      when(mockRecordRepo.getRecordById('rec1')).thenAnswer((_) async => record);
      when(mockSearchRepo.syncRecordIndex(any)).thenAnswer((_) async {});

      final result = await processor.processNextItem();

      expect(result, isTrue);

      // Verify Flow
      verify(mockSecurityHelper.decryptDataFromFile('/path', 'key')).called(1);
      verify(mockOcrService.recognizeText(decryptedBytes, mimeType: 'image/jpeg')).called(1);
      
      // Verify Update Image
      verify(mockImageRepo.updateOCRData('img1', any, rawJson: anyNamed('rawJson'), confidence: anyNamed('confidence'))).called(1);
      verify(mockImageRepo.updateImageMetadata('img1', hospitalName: anyNamed('hospitalName'), visitDate: anyNamed('visitDate'))).called(1);

      // Verify Record Status (High Confidence -> Archived)
      verify(mockRecordRepo.updateStatus('rec1', RecordStatus.archived)).called(1);

      // Verify Search Index
      verify(mockSearchRepo.syncRecordIndex('rec1')).called(1);

      // Verify Queue Completion
      verify(mockQueueRepo.updateStatus('1', OCRJobStatus.completed)).called(1);
    });

    test('Low confidence flow (Processing -> Review)', () async {
      final item = OCRQueueItem(
          id: '1', imageId: 'img1', status: OCRJobStatus.pending, 
          createdAt: DateTime.now(), updatedAt: DateTime.now());
      final image = MedicalImage(
          id: 'img1', recordId: 'rec1', filePath: '/path', encryptionKey: 'key',
          thumbnailEncryptionKey: 'key_thumb', thumbnailPath: '/path_thumb', mimeType: 'image/jpeg',
          createdAt: DateTime.now()
      );
      final record = MedicalRecord(
          id: 'rec1', personId: 'p1', notedAt: DateTime.now(),
          createdAt: DateTime.now(), updatedAt: DateTime.now(),
          status: RecordStatus.processing
      );
      const ocrResult = OCRResult(text: 'No Clear Data', confidence: 0.5);

      when(mockQueueRepo.dequeue()).thenAnswer((_) async => item);
      when(mockImageRepo.getImageById('img1')).thenAnswer((_) async => image);
      when(mockSecurityHelper.decryptDataFromFile(any, any)).thenAnswer((_) async => Uint8List(0));
      when(mockOcrService.recognizeText(any, mimeType: anyNamed('mimeType'))).thenAnswer((_) async => ocrResult);
      when(mockRecordRepo.getRecordById('rec1')).thenAnswer((_) async => record);
      when(mockSearchRepo.syncRecordIndex(any)).thenAnswer((_) async {});

      await processor.processNextItem();

      // Verify Record Status (Low Confidence -> Review)
      verify(mockRecordRepo.updateStatus('rec1', RecordStatus.review)).called(1);
    });

    test('Failure handling', () async {
      final item = OCRQueueItem(
          id: '1', imageId: 'img1', status: OCRJobStatus.pending, 
          createdAt: DateTime.now(), updatedAt: DateTime.now());
      
      when(mockQueueRepo.dequeue()).thenAnswer((_) async => item);
      when(mockImageRepo.getImageById('img1')).thenThrow(Exception('DB Error'));

      final result = await processor.processNextItem();

      expect(result, isFalse);
      verify(mockQueueRepo.updateStatus('1', OCRJobStatus.failed, error: anyNamed('error'))).called(1);
    });
  });
}
