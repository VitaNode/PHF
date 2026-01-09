import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import '../../../logic/providers/ingestion_provider.dart';
import '../../../logic/providers/states/ingestion_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/active_button.dart';

class IngestionPage extends ConsumerStatefulWidget {
  const IngestionPage({super.key});

  @override
  ConsumerState<IngestionPage> createState() => _IngestionPageState();
}

class _IngestionPageState extends ConsumerState<IngestionPage> {
  @override
  void initState() {
    super.initState();
    // Auto-trigger picker if empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(ingestionControllerProvider).rawImages.isEmpty) {
        _showPickerMenu();
      }
    });
  }

  void _showPickerMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                ref.read(ingestionControllerProvider.notifier).takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
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

    ref.listen(ingestionControllerProvider.select((s) => s.status), (
      previous,
      next,
    ) {
      if (next == IngestionStatus.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('已进入后台 OCR 处理队列...')));
        Navigator.of(context).pop();
      } else if (next == IngestionStatus.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存受阻: ${state.errorMessage}')));
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.ingestion_title),
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
                        AppLocalizations.of(context)!.ingestion_grouped_report,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        AppLocalizations.of(
                          context,
                        )!.ingestion_grouped_report_hint,
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
                      AppLocalizations.of(context)!.ingestion_ocr_hint,
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
                        text: AppLocalizations.of(
                          context,
                        )!.ingestion_submit_button,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_outlined, size: 64, color: AppTheme.textHint),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.ingestion_empty_hint,
            style: const TextStyle(color: AppTheme.textHint),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _showPickerMenu,
            child: Text(AppLocalizations.of(context)!.ingestion_add_now),
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
