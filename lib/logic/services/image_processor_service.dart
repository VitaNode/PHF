import 'package:flutter/services.dart';

/// # ImageProcessorService
///
/// ## Description
/// 封装原生 OpenCV 图像处理通道。
class ImageProcessorService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.phf/image_processor',
  );

  /// 对图片进行 OpenCV 极致增强 (CLAHE + Bilateral + AdaptiveThreshold)
  ///
  /// 返回增强后的图片路径。
  Future<String> processImage(String path) async {
    try {
      final String result = await _channel.invokeMethod('processImage', {
        'path': path,
      });
      return result;
    } on PlatformException catch (e) {
      throw Exception('Image processing failed: ${e.message}');
    }
  }
}
