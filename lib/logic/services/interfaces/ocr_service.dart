/// # IOCRService Interface
///
/// ## Description
/// 定义端侧 OCR 识别服务的业务契约。
/// 实现类应分别在 Android (ML Kit) 和 iOS (Vision Framework) 侧提供具体实现。
///
/// ## Functions
/// - `recognizeText`: 对给定的图片字节流执行文字识别。
///
/// ## Security
/// - **Offline-First**: 必须保证在无网络环境下可用。
/// - **Deep Privacy**: 处理过程应在内存中完成，或使用安全的临时文件，处理后立即销毁。
library;

import 'dart:typed_data';
import '../../../data/models/ocr_result.dart';

abstract interface class IOCRService {
  /// 执行 OCR 识别
  ///
  /// [imageBytes]: 待识别图片的原始字节流。
  /// [mimeType]: 图片的 MIME 类型 (如 image/jpeg, image/png)。
  /// 
  /// 返回识别成功的 [OCRResult]。
  Future<OCRResult> recognizeText(Uint8List imageBytes, {String? mimeType});

  /// 释放服务资源 (如 OCR 引擎实例)
  Future<void> dispose();
}
