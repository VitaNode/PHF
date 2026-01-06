/// # iOS OCR Service Implementation
///
/// ## Description
/// 通过 MethodChannel 调用 iOS 原生 Vision Framework 实现离线文字识别。
///
/// ## Security
/// - **Secure Wipe**: 识别过程中生成的临时文件，必须在 `finally` 块中立即强制删除。
/// - **Native Vision**: 利用 iOS 内置 AI 能力，无需额外模型文件，隐私性好。
///
/// ## Repair Logs
/// [2026-01-06] 修复：集成 Talker 日志系统，升级至 OcrResult V2 模型，确保跨平台命名一致性。
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

import '../utils/secure_wipe_helper.dart';
import '../../data/models/ocr_result.dart';
import 'interfaces/ocr_service.dart';

class IOSOCRService implements IOCRService {
  static const MethodChannel _channel = MethodChannel('com.example.phf/ocr');
  final Talker? _talker;

  IOSOCRService({Talker? talker}) : _talker = talker;

  @override
  Future<OcrResult> recognizeText(
    Uint8List imageBytes, {
    String? mimeType,
    String language = 'zh-Hans',
  }) async {
    File? tempFile;
    try {
      _talker?.info(
        '[IOSOCRService] Starting iOS OCR ($language) for ${imageBytes.length} bytes',
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

      final ocrResult = OcrResult.fromJson(resultMap);
      _talker?.info(
        '[IOSOCRService] completed. Found ${ocrResult.pages.length} pages, ${ocrResult.blocks.length} blocks.',
      );

      return ocrResult;
    } catch (e, stack) {
      _talker?.handle(e, stack, '[IOSOCRService] OCR Failed');
      throw Exception('iOS OCR Logic Error: $e');
    } finally {
      // 4. Secure Wipe (Crucial)
      if (tempFile != null) {
        await SecureWipeHelper.wipe(tempFile);
        _talker?.debug('[IOSOCRService] Secure wipe of temp file completed.');
      }
    }
  }

  @override
  Future<void> dispose() async {
    // No explicit resource disposal needed for MethodChannel
  }
}
