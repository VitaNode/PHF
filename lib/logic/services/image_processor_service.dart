import 'package:flutter/services.dart';

/// # ImageProcessorService
///
/// ## Description
/// 封装原生 OpenCV 图像处理通道。
class ImageProcessorService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.phf/image_processor',
  );

  /// 对图片进行 OpenCV 极致增强
  ///
  /// [mode] 可选值为 'UPLOAD' 或 'CAMERA'。
  /// 返回增强后的图片路径。
  Future<String> processImage(String path, {String mode = 'CAMERA'}) async {
    try {
      final String? result = await _channel.invokeMethod<String>(
        'processImage',
        {'path': path, 'mode': mode},
      );
      if (result == null) throw Exception('Processing returned null');
      return result;
    } on PlatformException catch (e) {
      throw Exception('Image processing failed: ${e.message}');
    }
  }
}
