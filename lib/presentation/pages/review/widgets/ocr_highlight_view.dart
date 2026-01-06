import 'package:flutter/material.dart';
import '../../../../data/models/ocr_result.dart';
import '../../../../presentation/theme/app_theme.dart';

class OCRHighlightView extends StatelessWidget {
  final ImageProvider imageProvider;
  final OcrResult? ocrResult;
  final Size? actualImageSize; // 原始图片的实际尺寸 (width, height)

  const OCRHighlightView({
    super.key,
    required this.imageProvider,
    this.ocrResult,
    this.actualImageSize,
  });

  @override
  Widget build(BuildContext context) {
    if (ocrResult == null ||
        ocrResult!.blocks.isEmpty ||
        actualImageSize == null) {
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
          child: Image(image: imageProvider, fit: BoxFit.contain),
        );
      },
    );
  }
}

class _OCRHighlightPainter extends CustomPainter {
  final OcrResult result;
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
      scale = scaleX < scaleY ? scaleX : scaleY;
      // Center the image in the drawing area
      final double drawnWidth = actualImageSize.width * scale;
      final double drawnHeight = actualImageSize.height * scale;
      offsetX = (size.width - drawnWidth) / 2;
      offsetY = (size.height - drawnHeight) / 2;
    } else {
      scale = scaleX;
    }

    final double drawnWidth = actualImageSize.width * scale;
    final double drawnHeight = actualImageSize.height * scale;

    final paintStroke = Paint()
      ..color = AppTheme.primaryTeal.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final paintFill = Paint()
      ..color = AppTheme.secondaryTeal.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    for (final block in result.blocks) {
      // 2. Transform coordinates
      final Rect rect;
      if (result.version >= 2) {
        // Schema V2: Normalized ratios (0.0 - 1.0)
        rect = Rect.fromLTWH(
          block.x * drawnWidth + offsetX,
          block.y * drawnHeight + offsetY,
          block.w * drawnWidth,
          block.h * drawnHeight,
        );
      } else {
        // Schema V1: Raw pixel values (Legacy Android)
        // Note: Legacy iOS was already ratios but version was 1.
        // If we detect iOS and version 1, it might still be ratios.
        // But for consistency with previous bug (if any), we follow the scale logic.
        if (result.source == 'ios_vision') {
          // iOS was always ratios, so even in V1 we treat as ratios
          rect = Rect.fromLTWH(
            block.x * drawnWidth + offsetX,
            block.y * drawnHeight + offsetY,
            block.w * drawnWidth,
            block.h * drawnHeight,
          );
        } else {
          // Android V1 was pixels
          rect = Rect.fromLTWH(
            block.x * scale + offsetX,
            block.y * scale + offsetY,
            block.w * scale,
            block.h * scale,
          );
        }
      }

      // 3. Draw
      canvas.drawRect(rect, paintFill);
      canvas.drawRect(rect, paintStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _OCRHighlightPainter oldDelegate) {
    return oldDelegate.result != result ||
        oldDelegate.actualImageSize != actualImageSize;
  }
}
