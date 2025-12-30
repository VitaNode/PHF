import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:phf/core/services/path_provider_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PathProviderService service;

  setUp(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    service = PathProviderService();
  });

  group('PathProviderService', () {
    test('Initialize creates subdirectories', () async {
      await service.initialize();

      expect(Directory(service.dbDirPath).existsSync(), isTrue);
      expect(Directory(service.imagesDirPath).existsSync(), isTrue);
      expect(Directory(service.tempDirPath).existsSync(), isTrue);

      expect(service.dbDirPath.endsWith('db'), isTrue);
      expect(service.imagesDirPath.endsWith('images'), isTrue);
    });

    test('clearTemp removes files in temp directory', () async {
      await service.initialize();
      
      final tempFile = File('${service.tempDirPath}/test.txt');
      await tempFile.writeAsString('hello');
      expect(tempFile.existsSync(), isTrue);

      await service.clearTemp();
      expect(tempFile.existsSync(), isFalse);
    });

    test('Accessing paths before init throws StateError', () {
      final uninitService = PathProviderService();
      expect(() => uninitService.dbDirPath, throwsStateError);
    });
  });
}
