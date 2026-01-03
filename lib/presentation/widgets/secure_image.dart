// SecureImage Component
//
// Description:
// 安全图片展示组件。
// 负责从加密文件路径异步加载、解密并在内存中展示图片。
//
// Features:
// - Async Decryption: 使用 FileSecurityHelper.decryptDataFromFile 在内存中解密。
// - Secure: 绝不将解密后的图片写入磁盘。
// - States: 处理加载中 (Shimmer)、失败 (Error Icon) 和成功状态。
// - Cache: (Phase 2) 可结合 flutter_cache_manager 的内存缓存机制 (not disk)。
//
// Usage:
// SecureImage(
//   imagePath: '/path/to/encrypted/file.enc',
//   encryptionKey: 'base64key...',
//   width: 100,
//   height: 100,
//   fit: BoxFit.cover,
// )

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/providers/core_providers.dart';
import '../theme/app_theme.dart';

class SecureImage extends ConsumerStatefulWidget {
  final String imagePath;
  final String encryptionKey;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final Widget Function(BuildContext context, ImageProvider imageProvider)? builder;

  const SecureImage({
    super.key,
    required this.imagePath,
    required this.encryptionKey,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.builder,
  });

  @override
  ConsumerState<SecureImage> createState() => _SecureImageState();
}

class _SecureImageState extends ConsumerState<SecureImage> {
  Future<Uint8List>? _decryptionFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant SecureImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath || 
        oldWidget.encryptionKey != widget.encryptionKey) {
      _load();
    }
  }

  void _load() {
    final helper = ref.read(fileSecurityHelperProvider);
    final pathService = ref.read(pathProviderServiceProvider);
    
    // Resolve absolute path from relative sandbox path
    final fullPath = widget.imagePath.startsWith('/')
        ? widget.imagePath
        : '${pathService.sandboxRoot}/${widget.imagePath}';

    _decryptionFuture = helper.decryptDataFromFile(fullPath, widget.encryptionKey);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.zero;

    return ClipRRect(
      borderRadius: radius,
      child: FutureBuilder<Uint8List>(
        future: _decryptionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildPlaceholder(context);
          } else if (snapshot.hasError) {
             debugPrint('SecureImage error: ${snapshot.error}');
             return _buildError(context);
          } else if (snapshot.hasData) {
            final imageProvider = MemoryImage(snapshot.data!);
            
            if (widget.builder != null) {
              return widget.builder!(context, imageProvider);
            }

            return Image(
              image: imageProvider,
              width: widget.width,
              height: widget.height,
              fit: widget.fit ?? BoxFit.cover,
              gaplessPlayback: true,
            );
          }
          return _buildPlaceholder(context);
        },
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: AppTheme.bgGray,
      child: const Center(
        child: SizedBox(
          width: 20, 
          height: 20, 
          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary)
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: AppTheme.bgGray,
      child: const Center(
        child: Icon(Icons.broken_image_rounded, color: AppTheme.textHint, size: 24),
      ),
    );
  }
}
