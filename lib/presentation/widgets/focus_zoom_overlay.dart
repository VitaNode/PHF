/// # FocusZoomOverlay Component
///
/// ## Description
/// 字段聚焦放大预览组件。用于在编辑 OCR 结果时，弹出一个局部放大的原始图片区域，方便对照校对。
///
/// ## Features
/// - **Secure**: 继承 `SecureImage` 的内存解密逻辑，不留磁盘痕迹。
/// - **Layout-Aware**: 接收归一化坐标 [x, y, w, h]，自动计算裁剪区域。
/// - **Visual Aid**: 提供高亮边框和阴影，增强层级感。
library;

import 'package:flutter/material.dart';
import 'secure_image.dart';
import '../theme/app_theme.dart';

class FocusZoomOverlay extends StatelessWidget {
  final String imagePath;
  final String encryptionKey;
  final List<double> normalizedRect; // [x, y, w, h] (0.0 - 1.0)
  final double scale;

  const FocusZoomOverlay({
    super.key,
    required this.imagePath,
    required this.encryptionKey,
    required this.normalizedRect,
    this.scale = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    if (normalizedRect.length < 4) return const SizedBox();

    final x = normalizedRect[0];
    final y = normalizedRect[1];
    final w = normalizedRect[2];
    final h = normalizedRect[3];

    return Container(
      height: 120, // 固定的预览高度
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SecureImage(
        imagePath: imagePath,
        encryptionKey: encryptionKey,
        fit: BoxFit.none,
        builder: (context, imageProvider) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // 计算 Alignment:
              // Alignment(x, y) 范围是 -1 到 1.
              // 0.0 -> -1.0, 0.5 -> 0.0, 1.0 -> 1.0
              final alignmentX = (x + w / 2) * 2 - 1;
              final alignmentY = (y + h / 2) * 2 - 1;

              return FractionallySizedBox(
                widthFactor: scale / w.clamp(0.01, 1.0),
                heightFactor: scale / h.clamp(0.01, 1.0),
                child: Container(
                  alignment: Alignment(alignmentX, alignmentY),
                  child: Image(image: imageProvider, fit: BoxFit.contain),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
