import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phf/logic/services/ios_ocr_service.dart';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return '.';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late IOSOCRService service;
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
    service = IOSOCRService();
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('com.example.phf/ocr'), (MethodCall methodCall) async {
      log.add(methodCall);
      if (methodCall.method == 'recognizeText') {
        final Map<String, dynamic> result = {
          'text': 'Mock Text',
          'blocks': [
            {'text': 'Mock', 'left': 0.1, 'top': 0.1, 'width': 0.2, 'height': 0.1}
          ],
          'confidence': 0.99
        };
        return jsonEncode(result);
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('com.example.phf/ocr'), null);
  });

  test('recognizeText calls native method and parses result', () async {
    final Uint8List mockBytes = Uint8List.fromList([0, 1, 2, 3]);

    final result = await service.recognizeText(mockBytes);

    expect(log, hasLength(1));
    expect(log.first.method, 'recognizeText');
    expect(log.first.arguments, isA<Map>());
    expect((log.first.arguments as Map)['imagePath'], contains('ocr_temp_'));

    expect(result.text, 'Mock Text');
    expect(result.blocks.length, 1);
    expect(result.blocks.first.text, 'Mock');
    expect(result.confidence, 0.99);
  });
}
