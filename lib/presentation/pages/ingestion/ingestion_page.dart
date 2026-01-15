import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import '../../../logic/providers/ingestion_provider.dart';
import '../../../logic/providers/states/ingestion_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/active_button.dart';

/// # IngestionPage Component
///
/// ## Description
/// 病历录入页面。支持原生文档扫描、基础拍照及相册选择。
///
/// ## Features
/// - **Simulator Detection**: 在模拟器环境下自动隐藏原生扫描仪入口。
/// - **Native Scanning**: 真机环境下启用 VisionKit/MLKit 扫描仪。
/// - **OpenCV Enhancement**: 扫描后的图片自动进入 OpenCV 增强管线。
class IngestionPage extends ConsumerStatefulWidget {
  const IngestionPage({super.key});

  @override
  ConsumerState<IngestionPage> createState() => _IngestionPageState();
}

class _IngestionPageState extends ConsumerState<IngestionPage> {
  bool _isSimulator = false;

  @override
  void initState() {
    super.initState();
    _checkSimulator();
    // Auto-trigger picker if empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(ingestionControllerProvider).rawImages.isEmpty) {
        _showPickerMenu();
      }
    });
  }

  Future<void> _checkSimulator() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      if (mounted) {
        setState(() {
          _isSimulator = !iosInfo.isPhysicalDevice;
        });
      }
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      if (mounted) {
        setState(() {
          _isSimulator = !androidInfo.isPhysicalDevice;
        });
      }
    }
  }

  void _showPickerMenu() {
    final l10n = AppLocalizations.of(context)!;
    // Hide native scanner only on simulator.
    // Android will use auto-fallback to regular camera if scan fails.
    final bool showNativeScanner = !_isSimulator;

    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showNativeScanner) ...[
              ListTile(
                leading: const Icon(
                  Icons.document_scanner,
                  color: AppTheme.primary,
                ),
                title: const Text(
                  '文档扫描 (增强模式)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(ingestionControllerProvider.notifier)
                      .scanDocuments();
                },
              ),
              const Divider(height: 1),
            ],
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.ingestion_take_photo),
              onTap: () {
                Navigator.pop(context);
                ref.read(ingestionControllerProvider.notifier).takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.ingestion_pick_gallery),
              onTap: () {
                Navigator.pop(context);
                ref.read(ingestionControllerProvider.notifier).pickImages();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ingestionControllerProvider);
    final notifier = ref.read(ingestionControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(ingestionControllerProvider.select((s) => s.status), (
      previous,
      next,
    ) {
      if (next == IngestionStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.ingestion_processing_queue)),
        );
        Navigator.of(context).pop();
      } else if (next == IngestionStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.ingestion_save_error(state.errorMessage ?? '')),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: Text(l10n.ingestion_title),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined),
            onPressed: _showPickerMenu,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.rawImages.isEmpty
          ? _buildEmpty(context)
          : _buildGrid(context, state, notifier),
      bottomNavigationBar: state.rawImages.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.ingestion_grouped_report,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        l10n.ingestion_grouped_report_hint,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textHint,
                        ),
                      ),
                      value: state.isGroupedReport,
                      onChanged: (val) => notifier.toggleGroupedReport(val),
                      activeTrackColor: AppTheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.ingestion_ocr_hint,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ActiveButton(
                        text: l10n.ingestion_submit_button,
                        onPressed: () => notifier.submit(),
                        isLoading: state.status == IngestionStatus.processing,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isSimulator) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_outlined,
              size: 64,
              color: AppTheme.textHint,
            ),
            const SizedBox(height: 16),
            const Text(
              '模拟器模式：仅支持基础拍照/相册',
              style: TextStyle(color: AppTheme.textHint),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showPickerMenu,
              child: Text(l10n.ingestion_add_now),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.document_scanner_outlined,
            size: 64,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 16),
          const Text(
            '高清识别首选',
            style: TextStyle(color: AppTheme.textHint, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () =>
                ref.read(ingestionControllerProvider.notifier).scanDocuments(),
            child: const Text('扫描文档'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _showPickerMenu,
            child: const Text('其他方式添加...'),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    IngestionState state,
    IngestionController notifier,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: state.rawImages.length,
      itemBuilder: (context, index) {
        final image = state.rawImages[index];
        final rotation = state.rotations[index];

        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: RotatedBox(
                  quarterTurns: rotation ~/ 90,
                  child: Image.file(File(image.path), fit: BoxFit.cover),
                ),
              ),
              // Toolbar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 36,
                  color: Colors.black54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.rotate_right,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () => notifier.rotateImage(index),
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () => notifier.removeImage(index),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              // Index
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
