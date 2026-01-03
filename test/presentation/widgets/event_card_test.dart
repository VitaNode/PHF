
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/core/security/file_security_helper.dart';
import 'package:phf/core/services/path_provider_service.dart';
import 'package:phf/data/models/image.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/presentation/widgets/event_card.dart';

import 'package:phf/data/models/tag.dart';
import 'package:phf/data/repositories/interfaces/tag_repository.dart';

import 'event_card_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FileSecurityHelper>(), 
  MockSpec<PathProviderService>(),
  MockSpec<ITagRepository>(),
])
void main() {
  late MockFileSecurityHelper mockFileSecurityHelper;
  late MockPathProviderService mockPathProviderService;
  late MockITagRepository mockTagRepository;
  
  Widget createSubject(MedicalRecord record, {MedicalImage? image}) {
    return ProviderScope(
      overrides: [
        fileSecurityHelperProvider.overrideWithValue(mockFileSecurityHelper),
        pathProviderServiceProvider.overrideWithValue(mockPathProviderService),
        tagRepositoryProvider.overrideWithValue(mockTagRepository),
        allTagsProvider.overrideWith((ref) async {
          return mockTagRepository.getAllTags();
        }),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EventCard(record: record, firstImage: image),
        ),
      ),
    );
  }

  group('EventCard', () {
    setUp(() {
      mockFileSecurityHelper = MockFileSecurityHelper();
      mockPathProviderService = MockPathProviderService();
      mockTagRepository = MockITagRepository();
    });

    void setupMocks() {
        when(mockPathProviderService.sandboxRoot).thenReturn('/mock/sandbox');
        when(mockPathProviderService.getSecureFile(any)).thenAnswer((realInvocation) {
          final path = realInvocation.positionalArguments[0] as String;
          return Future.value(File('/mock/sandbox/$path'));
        });
        when(mockTagRepository.getAllTags()).thenAnswer((_) async => []);
    }

    testWidgets('displays hospital name and date', (widgetTester) async {
      setupMocks();
      
      final record = MedicalRecord(
        id: 'r1',
        personId: 'p1',
        hospitalName: 'Test Hospital',
        notedAt: DateTime(2023, 10, 25),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: RecordStatus.archived,
      );

      await widgetTester.pumpWidget(createSubject(record));

      expect(find.text('Test Hospital'), findsOneWidget);
      expect(find.text('2023.10.25'), findsOneWidget);
    });

    testWidgets('displays secure image when provided', (widgetTester) async {
      setupMocks();

      final record = MedicalRecord(
        id: 'r1',
        personId: 'p1',
        notedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        images: [], // Will be updated below
      );

      final image = MedicalImage(
        id: 'i1',
        recordId: 'r1',
        encryptionKey: 'base64Key',
        thumbnailEncryptionKey: 'base64ThumbKey',
        filePath: 'orig.enc',
        thumbnailPath: 'thumb.enc',
        createdAt: DateTime.now(),
      );

      final recordWithImage = record.copyWith(images: [image]);

      // Mock decryption
      final fakePng = Uint8List.fromList([
        // Minimal 1x1 Transparent PNG
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 
        0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 
        0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 
        0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 
        0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
      ]);

      when(mockFileSecurityHelper.decryptDataFromFile(any, any))
          .thenAnswer((_) async => fakePng);

      await widgetTester.pumpWidget(createSubject(recordWithImage));
      
      // Initial State (Placeholder)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // After load
      await widgetTester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays tags if present on images', (widgetTester) async {
       setupMocks();
       final tag = Tag(id: 't1', name: 'Tag A', createdAt: DateTime.now(), color: '#008080');
       when(mockTagRepository.getAllTags()).thenAnswer((_) async => [tag]);

       final image = MedicalImage(
        id: 'i1',
        recordId: 'r1',
        encryptionKey: 'base64Key',
        thumbnailEncryptionKey: 'base64ThumbKey',
        filePath: 'orig.enc',
        thumbnailPath: 'thumb.enc',
        createdAt: DateTime.now(),
        tagIds: ['t1'],
      );

      final record = MedicalRecord(
        id: 'r1',
        personId: 'p1',
        notedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        images: [image],
      );

      await widgetTester.pumpWidget(createSubject(record));
      await widgetTester.pumpAndSettle();

      expect(find.text('Tag A'), findsOneWidget);
    });
  });
}
