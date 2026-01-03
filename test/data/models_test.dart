import 'package:flutter_test/flutter_test.dart';
import 'package:phf/data/models/person.dart';
import 'package:phf/data/models/tag.dart';
import 'package:phf/data/models/image.dart';
import 'package:phf/data/models/record.dart';

void main() {
  group('Entity Sanity Tests (Fixed)', () {
    final testTime = DateTime(2025, 12, 29, 12, 0);

    test('Person serialization and defaults', () {
      final person = Person(
        id: 'p1',
        nickname: 'Me',
        isDefault: true,
        createdAt: testTime,
      );

      final json = person.toJson();
      expect(json['id'], 'p1');
      expect(json['nickname'], 'Me');
      expect(json['isDefault'], true);
      
      final fromJson = Person.fromJson(json);
      expect(fromJson, person);
    });

    test('Tag serialization with personId', () {
      final tag = Tag(
        id: 't1',
        personId: 'p1',
        name: 'Report',
        color: '#FF0000',
        createdAt: testTime,
      );

      final json = tag.toJson();
      expect(json['personId'], 'p1');
      expect(Tag.fromJson(json), tag);
    });

    test('MedicalImage metadata and fields', () {
      final image = MedicalImage(
        id: 'i1',
        recordId: 'r1',
        encryptionKey: 'base64_key',
        thumbnailEncryptionKey: 'base64_thumb_key',
        filePath: 'path/to/file',
        thumbnailPath: 'path/to/thumb',
        width: 100,
        height: 100,
        fileSize: 1024,
        createdAt: testTime,
      );

      expect(image.mimeType, 'image/jpeg'); // Default
      expect(image.displayOrder, 0); // Default
      
      final json = image.toJson();
      expect(json['mimeType'], 'image/jpeg');
      expect(json['fileSize'], 1024);
      expect(MedicalImage.fromJson(json), image);
    });

    test('MedicalRecord schema and title logic', () {
      final record = MedicalRecord(
        id: 'r1',
        personId: 'p1',
        hospitalName: 'Mayo Clinic',
        notes: 'Annual checkup.',
        notedAt: DateTime(2023, 1, 1),
        createdAt: testTime,
        updatedAt: testTime,
      );

      expect(record.status, RecordStatus.processing); // Default
      expect(record.title, 'Mayo Clinic'); // Getter logic
      
      final json = record.toJson();
      expect(json['personId'], 'p1');
      expect(json['hospitalName'], 'Mayo Clinic');
      expect(json['status'], 'processing');
      
      final fromJson = MedicalRecord.fromJson(json);
      expect(fromJson.title, 'Mayo Clinic');
      expect(fromJson, record);
    });

    test('MedicalRecord title fallback', () {
       final record = MedicalRecord(
        id: 'r2',
        personId: 'p1',
        notedAt: DateTime(2023, 1, 1),
        createdAt: testTime,
        updatedAt: testTime,
      );
      expect(record.title, '医疗记录');
    });
  });
}
