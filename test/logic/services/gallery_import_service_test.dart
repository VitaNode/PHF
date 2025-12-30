import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/logic/services/gallery_import_service.dart';

@GenerateNiceMocks([MockSpec<ImagePicker>()])
import 'gallery_import_service_test.mocks.dart';

void main() {
  late GalleryImportService service;
  late MockImagePicker mockPicker;

  setUp(() {
    mockPicker = MockImagePicker();
    service = GalleryImportService(picker: mockPicker);
  });

  group('GalleryImportService', () {
    test('pickImages returns list of XFile when picker succeeds', () async {
      // Arrange
      final expectedFiles = [
        XFile('/path/to/image1.jpg'),
        XFile('/path/to/image2.jpg'),
      ];
      when(mockPicker.pickMultiImage()).thenAnswer((_) async => expectedFiles);

      // Act
      final result = await service.pickImages();

      // Assert
      expect(result.length, 2);
      expect(result[0].path, '/path/to/image1.jpg');
      verify(mockPicker.pickMultiImage()).called(1);
    });

    test('pickImages returns empty list when picker returns empty', () async {
      when(mockPicker.pickMultiImage()).thenAnswer((_) async => []);

      final result = await service.pickImages();

      expect(result, isEmpty);
    });
    
    // Note: pickMultiImage returns unmodifiable list usually, 
    // but here we just check our returned list.
  });
}
