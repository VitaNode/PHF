/// # Full Image Viewer Component
///
/// ## Description
/// 全屏安全图片浏览器。
/// 
/// ## Features
/// - **Secure Decryption**: 使用 `SecureImage` 在内存中解密展示大图。
/// - **Gesture Support**: 支持双指缩放 (InteractiveViewer) 和左右滑动切换 (PageView)。
/// - **Memory Safety**: 页面销毁时自动丢弃解密数据（依靠 Flutter Widget 生命周期）。
///
/// ## Usage
/// ```dart
/// FullImageViewer(
///   images: record.images,
///   initialIndex: 0,
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:phf/data/models/image.dart';
import 'secure_image.dart';

class FullImageViewer extends StatefulWidget {
  final List<MedicalImage> images;
  final int initialIndex;

  const FullImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<FullImageViewer> createState() => _FullImageViewerState();
}

class _FullImageViewerState extends State<FullImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _currentIndex);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black.withValues(alpha: 0.5),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, _currentIndex),
          ),
          title: Text(
            '${_currentIndex + 1} / ${widget.images.length}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final image = widget.images[index];
            return InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Center(
                child: SecureImage(
                  imagePath: image.filePath, // Use original high-res encrypted file
                  encryptionKey: image.encryptionKey, 
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
