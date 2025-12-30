import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:phf/logic/services/image_processing_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ImageProcessingService service;

  // A simple 1x1 Red Pixel PNG
  final redPixelPng = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // Signature
    0x00, 0x00, 0x00, 0x0D, // IHDR length
    0x49, 0x48, 0x44, 0x52, // IHDR
    0x00, 0x00, 0x00, 0x01, // Width 1
    0x00, 0x00, 0x00, 0x01, // Height 1
    0x08, 0x02, 0x00, 0x00, 0x00, // Bit depth, color type
    0x90, 0x77, 0x53, 0xDE, // CRC
    0x00, 0x00, 0x00, 0x0C, // IDAT length
    0x49, 0x44, 0x41, 0x54, // IDAT
    0x08, 0xD7, 0x63, 0xF8, 0xCF, 0xC0, 0x00, 0x00, 0x03, 0x01, 0x01, 0x00, // Data
    0x18, 0xDD, 0x8D, 0xB0, // CRC
    0x00, 0x00, 0x00, 0x00, // IEND length
    0x49, 0x45, 0x4E, 0x44, // IEND
    0xAE, 0x42, 0x60, 0x82  // CRC
  ]);

  setUp(() {
    service = ImageProcessingService();
  });

  group('ImageProcessingService', () {
    test('compressImage returns valid JPEG data', () async {
      final jpegData = await service.compressImage(data: redPixelPng);
      
      // JPEG signature Check (FF D8)
      expect(jpegData.length, greaterThan(2));
      expect(jpegData[0], 0xFF);
      expect(jpegData[1], 0xD8);
      
      final decoded = img.decodeJpg(jpegData);
      expect(decoded, isNotNull);
      expect(decoded!.width, 1);
      expect(decoded.height, 1);
    });

    test('generateThumbnail resizes image', () async {
      // Create a larger image (400x400) specifically for resizing test
      final largeImage = img.Image(width: 400, height: 400);
      final largeJpg = img.encodeJpg(largeImage);
      
      final thumbnailData = await service.generateThumbnail(
        data: Uint8List.fromList(largeJpg),
        width: 100, // Target width
      );

      final decodedThumb = img.decodeJpg(thumbnailData);
      expect(decodedThumb, isNotNull);
      expect(decodedThumb!.width, 100);
      // Aspect ratio maintained => height should also be 100
      expect(decodedThumb.height, 100);
    });

    test('getDimensions returns correct size', () async {
      final dimensions = await service.getDimensions(redPixelPng);
      expect(dimensions.width, 1);
      expect(dimensions.height, 1);
    });

    test('secureWipe deletes file', () async {
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/test_wipe.tmp');
      await tempFile.writeAsString('I will be deleted');
      
      expect(await tempFile.exists(), isTrue);

      await service.secureWipe(tempFile.path);

      expect(await tempFile.exists(), isFalse);
    });
  });
}
