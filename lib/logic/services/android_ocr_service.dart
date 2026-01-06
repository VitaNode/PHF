/// # Android OCR Service Implementation (Native Bridge)
///
/// ## Description
/// 通过 MethodChannel 调用 Android 原生 ML Kit 实现离线文字识别。
/// 这种方式彻底解决了 google_mlkit 插件在 iOS 端的架构冲突。
///
/// ## Security
/// - **Secure Wipe**: 识别过程中生成的临时文件，必须在 `finally` 块中立即强制删除。
library;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../utils/secure_wipe_helper.dart';
import '../../data/models/ocr_result.dart';
import 'interfaces/ocr_service.dart';

class AndroidOCRService implements IOCRService {
  static const MethodChannel _channel = MethodChannel('com.example.phf/ocr');

  @override
  Future<OCRResult> recognizeText(
    Uint8List imageBytes, {
    String? mimeType,
    String language = 'zh',
  }) async {
    File? tempFile;
    try {
      log(
        'Starting Native Android OCR ($language) for image size: ${imageBytes.length} bytes',
        name: 'AndroidOCRService',
      );

      // 1. Create secure temp file
      final tempDir = await getTemporaryDirectory();
      final uuid = const Uuid().v4();
      tempFile = File('${tempDir.path}/ocr_temp_$uuid.jpg');
      await tempFile.writeAsBytes(imageBytes, flush: true);

      // 2. Call Native Bridge
      final dynamic result = await _channel.invokeMethod('recognizeText', {
        'imagePath': tempFile.path,
        'language': language,
      });
      final String jsonResult = result as String;

      // 3. Parse Result
      final dynamic decoded = jsonDecode(jsonResult);
      final Map<String, dynamic> resultMap = decoded as Map<String, dynamic>;

      return OCRResult.fromJson(resultMap);
    } catch (e, stack) {
      log(
        'Android OCR Failed: $e',
        name: 'AndroidOCRService',
        error: e,
        stackTrace: stack,
      );
      throw Exception('Android OCR Logic Error: $e');
    } finally {
      // 4. Secure Wipe (Crucial)
      if (tempFile != null) {
        await SecureWipeHelper.wipe(tempFile);
      }
    }
  }

  @override
  Future<void> dispose() async {
    // No explicit resource disposal needed for MethodChannel
  }
}
