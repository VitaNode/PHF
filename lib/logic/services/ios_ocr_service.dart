/// # iOS OCR Service Implementation
///
/// ## Description
/// 通过 MethodChannel 调用 iOS 原生 Vision Framework 实现离线文字识别。
///
/// ## Security
/// - **Secure Wipe**: 识别过程中生成的临时文件，必须在 `finally` 块中立即强制删除。
/// - **Native Vision**: 利用 iOS 内置 AI 能力，无需额外模型文件，隐私性好。
///
/// ## Implementation Details
/// - 通道名称: `com.example.phf/ocr`
/// - 方法: `recognizeText`
/// - 参数: `imagePath` (String)
/// - 返回: JSON String (为了跨平台序列化一致性，Native端返回 JSON 字符串比 Map 更有序可控)
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

class IOSOCRService implements IOCRService {
  static const MethodChannel _channel = MethodChannel('com.example.phf/ocr');

  @override
  Future<OCRResult> recognizeText(
    Uint8List imageBytes, {
    String? mimeType,
    String language = 'zh-Hans',
  }) async {
    File? tempFile;
    try {
      log(
        'Starting iOS OCR ($language) for image size: ${imageBytes.length} bytes',
        name: 'IOSOCRService',
      );

      // 1. Create secure temp file
      final tempDir = await getTemporaryDirectory();
      final uuid = const Uuid().v4();
      tempFile = File('${tempDir.path}/ocr_temp_$uuid.jpg');
      await tempFile.writeAsBytes(imageBytes, flush: true);

      // 2. Call Native Method
      final dynamic result = await _channel.invokeMethod('recognizeText', {
        'imagePath': tempFile.path,
        'language': language,
      });
      final String jsonResult = result as String;

      // 3. Parse Result
      final dynamic decoded = jsonDecode(jsonResult);
      final Map<String, dynamic> resultMap = decoded as Map<String, dynamic>;

      final ocrResult = OCRResult.fromJson(resultMap);
      log(
        'iOS OCR completed. Found ${ocrResult.blocks.length} blocks.',
        name: 'IOSOCRService',
      );

      return ocrResult;
    } catch (e, stack) {
      log(
        'iOS OCR Failed: $e',
        name: 'IOSOCRService',
        error: e,
        stackTrace: stack,
      );
      throw Exception('iOS OCR Logic Error: $e');
    } finally {
      // 4. Secure Wipe (Crucial)
      if (tempFile != null) {
        await SecureWipeHelper.wipe(tempFile);
        log(
          'Secure wipe of temp iOS OCR file completed.',
          name: 'IOSOCRService',
        );
      }
    }
  }

  @override
  Future<void> dispose() async {
    // No explicit resource disposal needed for MethodChannel
  }
}
