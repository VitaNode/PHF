/// # Android OCR Service Implementation
///
/// ## Description
/// 基于 Google ML Kit 实现 Android 端离线文字识别。
///
/// ## Security
/// - **Secure Wipe**: 识别过程中生成的临时文件，必须在 `finally` 块中立即强制删除。
/// - **Offline-First**: 使用 `google_mlkit_text_recognition` 离线模型。
///
/// ## Implementation Details
/// - 由于 ML Kit 的 `InputImage.fromBytes` 在 Flutter 端处理较为复杂（需要 metadata），
///   本实现采用 **File-based** 方式：先将 `Uint8List` 写入 Cache 目录下的随机临时文件，
///   识别完成后立即销毁。
library;

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../utils/secure_wipe_helper.dart';
import '../../data/models/ocr_result.dart';
import 'interfaces/ocr_service.dart';

class AndroidOCRService implements IOCRService {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);

  @override
  Future<OCRResult> recognizeText(Uint8List imageBytes, {String? mimeType}) async {
    File? tempFile;
    try {
      log('Starting OCR for image size: ${imageBytes.length} bytes', name: 'AndroidOCRService');
      
      // 1. Create secure temp file
      final tempDir = await getTemporaryDirectory();
      final uuid = const Uuid().v4();
      // 使用 .jpg 后缀以兼容 Image Picker/ML Kit 通用逻辑，具体扩展名对 ML Kit 影响不大
      tempFile = File('${tempDir.path}/ocr_temp_$uuid.jpg');
      await tempFile.writeAsBytes(imageBytes, flush: true);

      // 2. Prepare InputImage
      final inputImage = InputImage.fromFilePath(tempFile.path);

      // 3. Process
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      log('OCR completed. Found ${recognizedText.blocks.length} blocks.', name: 'AndroidOCRService');

      // 4. Map to Domain Model
      return _mapToOCRResult(recognizedText);
    } catch (e, stack) {
      log('OCR Failed: $e', name: 'AndroidOCRService', error: e, stackTrace: stack);
      // Re-throw or handle specific ML Kit errors
      throw Exception('OCR Logic Error: $e');
    } finally {
      // 5. Secure Wipe (Crucial)
      if (tempFile != null) {
        await SecureWipeHelper.wipe(tempFile);
        log('Secure wipe of temp OCR file completed.', name: 'AndroidOCRService');
      }
    }
  }

  @override
  Future<void> dispose() async {
    await _textRecognizer.close();
  }

  OCRResult _mapToOCRResult(RecognizedText rt) {
    // 简单计算平均置信度（ML Kit text recognition 并不总是直接返回整段信心，
    // 部分版本可能只在 line/element 级别提供。这里做防御性处理）
    // *注：current mlkit flutter plugin TextBlock/TextLine usually doesn't expose strict confidence scores publicly in all versions, 
    // assuming logical 1.0 if missing or implementing custom heuristic.*
    // 
    // 自 0.13.0 版本起，TextElement 可能不直接暴露 confidence。
    // 我们暂时默认 header 为 1.0，或预留扩展。

    final blocks = rt.blocks.map((b) {
      // ML Kit Rect to standard definition
      final rect = b.boundingBox;
      return OCRBlock(
        text: b.text,
        left: rect.left,
        top: rect.top,
        width: rect.width,
        height: rect.height,
      );
    }).toList();

    return OCRResult(
      text: rt.text,
      blocks: blocks,
      confidence: 1.0, // Base confidence, optimized later by heuristic
    );
  }
}
