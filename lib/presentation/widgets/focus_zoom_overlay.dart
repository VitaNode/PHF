/// # FocusZoomOverlay Component
///
/// ## Description
/// 字段聚焦放大预览组件。利用 CustomPainter 直接在 Canvas 上绘制解密后的图片局部，
/// 确保裁剪区域 [x, y, w, h] 精准对焦，解决组件叠加导致的黑屏或偏移问题。
library;

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/providers/core_providers.dart';
import '../theme/app_theme.dart';

class FocusZoomOverlay extends ConsumerStatefulWidget {
  final String imagePath;
  final String encryptionKey;
  final List<double> normalizedRect; // [x, y, w, h] (0.0 - 1.0)

  const FocusZoomOverlay({
    super.key,
    required this.imagePath,
    required this.encryptionKey,
    required this.normalizedRect,
  });

  @override
  ConsumerState<FocusZoomOverlay> createState() => _FocusZoomOverlayState();
}

class _FocusZoomOverlayState extends ConsumerState<FocusZoomOverlay> {
  ui.Image? _decodedImage;
  bool _isDecoding = false;

  @override
  void initState() {
    super.initState();
    _loadAndDecode();
  }

  @override
  void didUpdateWidget(FocusZoomOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _loadAndDecode();
    }
  }

  Future<void> _loadAndDecode() async {
    if (_isDecoding) return;
    setState(() {
      _isDecoding = true;
      _decodedImage = null;
    });

    try {
      final helper = ref.read(fileSecurityHelperProvider);
      final pathService = ref.read(pathProviderServiceProvider);
      final fullPath = widget.imagePath.startsWith('/')
          ? widget.imagePath
          : '${pathService.sandboxRoot}/${widget.imagePath}';

      final bytes = await helper.decryptDataFromFile(
        fullPath,
        widget.encryptionKey,
      );
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      if (mounted) {
        setState(() {
          _decodedImage = frame.image;
          _isDecoding = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDecoding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(color: AppTheme.primaryTeal, width: 2),
        ),
      ),
      child: _decodedImage == null
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : CustomPaint(
              painter: _ZoomMagnifierPainter(
                image: _decodedImage!,
                rect: widget.normalizedRect,
              ),
            ),
    );
  }
}

class _ZoomMagnifierPainter extends CustomPainter {
  final ui.Image image;
  final List<double> rect; // [x, y, w, h] normalized

  _ZoomMagnifierPainter({required this.image, required this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    if (rect.length < 4) return;

    // 1. 计算源矩形 (Source Rect in Image Pixels)
    // OCR 坐标通常是非常精准的物理坐标
    final srcX = rect[0] * image.width;
    final srcY = rect[1] * image.height;
    final srcW = rect[2] * image.width;
    final srcH = rect[3] * image.height;

    // 增加一点边距缓冲，避免切得太死
    final paddingW = srcW * 0.2;
    final paddingH = srcH * 0.4;

    final sourceRect = Rect.fromLTWH(
      (srcX - paddingW).clamp(0, image.width.toDouble()),
      (srcY - paddingH).clamp(0, image.height.toDouble()),
      (srcW + paddingW * 2).clamp(10, image.width.toDouble()),
      (srcH + paddingH * 2).clamp(10, image.height.toDouble()),
    );

    // 2. 计算目标矩形 (Destination Rect on Canvas)
    // 我们要让裁剪出来的区域比例适配当前的预览窗高度，同时保持内容居中且不失真
    final double canvasAspect = size.width / size.height;
    final double sourceAspect = sourceRect.width / sourceRect.height;

    Rect destRect;
    if (sourceAspect > canvasAspect) {
      // 图片太宽，以宽度为准
      final drawW = size.width;
      final drawH = size.width / sourceAspect;
      destRect = Rect.fromLTWH(0, (size.height - drawH) / 2, drawW, drawH);
    } else {
      // 图片太高，以高度为准
      final drawH = size.height;
      final drawW = size.height * sourceAspect;
      destRect = Rect.fromLTWH((size.width - drawW) / 2, 0, drawW, drawH);
    }

    // 3. 绘制
    final paint = Paint()..filterQuality = ui.FilterQuality.high;
    canvas.drawImageRect(image, sourceRect, destRect, paint);

    // 4. 视觉辅助：绘制一个中心准星或边框（可选）
    final framePaint = Paint()
      ..color = AppTheme.primaryTeal.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(destRect, framePaint);
  }

  @override
  bool shouldRepaint(_ZoomMagnifierPainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.rect != rect;
  }
}
