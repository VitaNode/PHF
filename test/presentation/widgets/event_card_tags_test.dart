import 'dart:convert';
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
import 'package:phf/data/models/tag.dart';
import 'package:phf/data/repositories/interfaces/tag_repository.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/logic/providers/person_provider.dart';
import 'package:phf/presentation/widgets/event_card.dart';

@GenerateNiceMocks([
  MockSpec<FileSecurityHelper>(),
  MockSpec<PathProviderService>(),
  MockSpec<ITagRepository>(),
])
import 'event_card_tags_test.mocks.dart';

class MockCurrentPersonIdController extends CurrentPersonIdController {
  final String id;
  MockCurrentPersonIdController(this.id);
  @override
  Future<String?> build() async => id;
}

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
        currentPersonIdControllerProvider.overrideWith(
          () => MockCurrentPersonIdController('p1'),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EventCard(record: record, firstImage: image),
        ),
      ),
    );
  }

  group('EventCard Tags Integration', () {
    setUp(() {
      mockFileSecurityHelper = MockFileSecurityHelper();
      mockPathProviderService = MockPathProviderService();
      mockTagRepository = MockITagRepository();

      final fakePng = Uint8List.fromList([
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x00,
        0x01,
        0x00,
        0x00,
        0x00,
        0x01,
        0x08,
        0x06,
        0x00,
        0x00,
        0x00,
        0x1F,
        0x15,
        0xC4,
        0x89,
        0x00,
        0x00,
        0x00,
        0x0A,
        0x49,
        0x44,
        0x41,
        0x54,
        0x78,
        0x9C,
        0x63,
        0x00,
        0x01,
        0x00,
        0x00,
        0x05,
        0x00,
        0x01,
        0x0D,
        0x0A,
        0x2D,
        0xB4,
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4E,
        0x44,
        0xAE,
        0x42,
        0x60,
        0x82,
      ]);

      when(mockPathProviderService.sandboxRoot).thenReturn('/mock/sandbox');
      when(
        mockFileSecurityHelper.decryptDataFromFile(any, any),
      ).thenAnswer((_) async => fakePng);
    });

    testWidgets('displays first image tag name instead of notes', (
      widgetTester,
    ) async {
      // Setup Data
      const tagId = 'tag_1';
      const tagName = 'Important Checkup';
      const noteText = 'Should not see this note';

      final record = MedicalRecord(
        id: 'r1',
        personId: 'p1',
        hospitalName: 'Hospital',
        notedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notes: noteText,
        status: RecordStatus.archived,
        tagsCache: jsonEncode([tagName]),
        images: [], // populated below
      );

      final image = MedicalImage(
        id: 'i1',
        recordId: 'r1',
        encryptionKey: 'key',
        thumbnailEncryptionKey: 'tk',
        filePath: 'path',
        thumbnailPath: 'thumb',
        createdAt: DateTime.now(),
        tagIds: [tagId],
      );
      final recordWithImage = record.copyWith(images: [image]);

      final tags = [
        Tag(
          id: tagId,
          name: tagName,
          color: '#FFFFFF',
          createdAt: DateTime.now(),
        ),
      ];

      // Setup Mocks
      when(
        mockTagRepository.getAllTags(personId: anyNamed('personId')),
      ).thenAnswer((_) async => tags);

      // Pump Widget
      await widgetTester.pumpWidget(createSubject(recordWithImage));
      await widgetTester.pumpAndSettle(); // Wait for FutureBuilder

      // Verify
      expect(find.text(tagName), findsOneWidget);
      expect(find.text(noteText), findsNothing);
    });

    testWidgets('fallbacks to notes if image has no tags', (
      widgetTester,
    ) async {
      const noteText = 'This is a note';

      final record = MedicalRecord(
        id: 'r1',
        personId: 'p1',
        hospitalName: 'Hospital',
        notedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notes: noteText,
        status: RecordStatus.archived,
      );

      final image = MedicalImage(
        id: 'i1',
        recordId: 'r1',
        encryptionKey: 'key',
        thumbnailEncryptionKey: 'tk',
        filePath: 'path',
        thumbnailPath: 'thumb',
        createdAt: DateTime.now(),
        tagIds: [], // Empty tags
      );

      await widgetTester.pumpWidget(
        createSubject(record.copyWith(images: [image])),
      );
      await widgetTester.pumpAndSettle();

      expect(
        find.text(noteText),
        findsNothing,
      ); // Notes no longer shown in EventCard
    });
  });
}
