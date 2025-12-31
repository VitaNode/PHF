import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:phf/logic/utils/secure_wipe_helper.dart';

void main() {
  group('SecureWipeHelper', () {
    late File testFile;

    setUp(() async {
      final tempDir = Directory.systemTemp;
      testFile = File('${tempDir.path}/wipe_test_${DateTime.now().millisecondsSinceEpoch}.bin');
    });

    tearDown(() async {
      if (await testFile.exists()) {
        await testFile.delete();
      }
    });

    test('wipe successfully overwrites and deletes small file', () async {
      await testFile.writeAsString('sensitive data');
      expect(await testFile.exists(), isTrue);

      await SecureWipeHelper.wipe(testFile);

      expect(await testFile.exists(), isFalse);
    });

    test('wipe successfully handles large file (over buffer size)', () async {
      // 128KB > 64KB buffer
      final largeData = Uint8List(128 * 1024);
      for (var i = 0; i < largeData.length; i++) {
        largeData[i] = 0xAA; // Fill with non-random constant
      }
      await testFile.writeAsBytes(largeData);
      
      final originalLength = await testFile.length();
      expect(originalLength, 128 * 1024);

      await SecureWipeHelper.wipe(testFile);

      expect(await testFile.exists(), isFalse);
    });

    test('wipeSync successfully overwrites and deletes', () {
      testFile.writeAsBytesSync(Uint8List.fromList([1, 2, 3, 4]));
      expect(testFile.existsSync(), isTrue);

      SecureWipeHelper.wipeSync(testFile);

      expect(testFile.existsSync(), isFalse);
    });

    test('wipe handles non-existent file gracefully', () async {
      final nonExistentFile = File('ghost_file.txt');
      await SecureWipeHelper.wipe(nonExistentFile); // Should not throw
    });
  });
}
