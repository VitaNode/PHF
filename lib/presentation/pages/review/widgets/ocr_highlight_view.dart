import 'package:flutter/material.dart';
import '../../../../data/models/ocr_result.dart';
import '../../../../presentation/theme/app_theme.dart';

class OCRHighlightView extends StatelessWidget {
  final ImageProvider imageProvider;
  final OCRResult? ocrResult;
  final Size? actualImageSize; // 原始图片的实际尺寸 (width, height)

  const OCRHighlightView({
    super.key,
    required this.imageProvider,
    this.ocrResult,
    this.actualImageSize,
  });

  @override
  Widget build(BuildContext context) {
    if (ocrResult == null || ocrResult!.blocks.isEmpty || actualImageSize == null) {
      return Image(image: imageProvider, fit: BoxFit.contain);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          foregroundPainter: _OCRHighlightPainter(
            ocrResult!,
            actualImageSize!,
            BoxFit.contain, // Default fit
          ),
          child: Image(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}

class _OCRHighlightPainter extends CustomPainter {
  final OCRResult result;
  final Size actualImageSize;
  final BoxFit fit;

  _OCRHighlightPainter(this.result, this.actualImageSize, this.fit);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Calculate scaling factors
    final double scaleX = size.width / actualImageSize.width;
    final double scaleY = size.height / actualImageSize.height;
    
    // For BoxFit.contain, we need to respect aspect ratio
    double scale = 1.0;
    double offsetX = 0.0;
    double offsetY = 0.0;

    if (fit == BoxFit.contain) {
      scale = scaleX < scaleY ? scaleX : scaleY; // fit width or height (smaller scale)
      // Center the image in the drawing area
      final double drawnWidth = actualImageSize.width * scale;
      final double drawnHeight = actualImageSize.height * scale;
      offsetX = (size.width - drawnWidth) / 2;
      offsetY = (size.height - drawnHeight) / 2;
    } else {
      // support other fits if needed (assuming contain for now)
      scale = scaleX;
    }

    final paintStroke = Paint()
      ..color = AppTheme.primaryTeal.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paintFill = Paint()
      ..color = AppTheme.secondaryTeal.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
      
    for (final block in result.blocks) {
      // 2. Transform coordinates
      // Block coordinates are typically raw pixel values from ML Kit
      final rect = Rect.fromLTWH(
        block.left * scale + offsetX,
        block.top * scale + offsetY,
        block.width * scale,
        block.height * scale,
      );

      // 3. Draw
      canvas.drawRect(rect, paintFill);
      canvas.drawRect(rect, paintStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _OCRHighlightPainter oldDelegate) {
    return oldDelegate.result != result || oldDelegate.actualImageSize != actualImageSize;
  }
}
