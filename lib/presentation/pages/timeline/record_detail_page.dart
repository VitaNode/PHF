/// # Record Detail Page
///
/// ## Description
/// 展示病历详情，支持图片轮播、OCR 结果查看。
/// 点击“编辑”将进入专用的校对模式 (ReviewEditPage)。
library;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import '../../../data/models/image.dart';
import '../../../data/models/ocr_result.dart';
import '../../../data/models/record.dart';
import '../../../data/models/tag.dart';
import '../../../logic/providers/core_providers.dart';
import '../../../logic/providers/timeline_provider.dart';
import '../../../logic/providers/ocr_status_provider.dart';
import '../../../logic/services/background_worker_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/l10n_helper.dart';
import '../../widgets/secure_image.dart';
import '../../widgets/full_image_viewer.dart';
import '../review/review_edit_page.dart';
import 'widgets/collapsible_ocr_card.dart';
import 'widgets/enhanced_ocr_view.dart';

class RecordDetailPage extends ConsumerStatefulWidget {
  final String recordId;

  const RecordDetailPage({super.key, required this.recordId});

  @override
  ConsumerState<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends ConsumerState<RecordDetailPage> {
  MedicalRecord? _record;
  List<MedicalImage> _images = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setupOcrListener();

    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_record == null || _images.isEmpty) {
      return Scaffold(body: Center(child: Text(l10n.detail_record_not_found)));
    }

    final currentImage = _images[_currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(flex: 4, child: _buildImageSection()),
          const Divider(height: 1),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildInfoView(currentImage),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final recordRepo = ref.read(recordRepositoryProvider);
      final imageRepo = ref.read(imageRepositoryProvider);

      final record = await recordRepo.getRecordById(widget.recordId);
      final images = await imageRepo.getImagesForRecord(widget.recordId);

      if (mounted) {
        setState(() {
          _record = record;
          _images = images;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _enterEditMode() async {
    if (_record == null) return;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewEditPage(
          record: _record!.copyWith(images: _images),
          isReviewMode: false,
        ),
      ),
    );
    if (result == true && mounted) {
      await _loadData();
      await ref.read(timelineControllerProvider.notifier).refresh();
    }
  }

  Future<void> _deleteCurrentImage() async {
    if (_images.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    final currentImage = _images[_currentIndex];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.detail_image_delete_title),
        content: Text(l10n.detail_image_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final imageRepo = ref.read(imageRepositoryProvider);
      await imageRepo.deleteImage(currentImage.id);
      if (_images.length == 1) {
        if (mounted) Navigator.pop(context);
        return;
      }
      ref.invalidate(timelineControllerProvider);
      await _loadData();
      if (_currentIndex >= _images.length) {
        _currentIndex = _images.length - 1;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.common_load_failed(e.toString()))),
        );
      }
    }
  }

  Future<void> _retriggerOCR() async {
    if (_images.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    final currentImage = _images[_currentIndex];
    setState(() => _isLoading = true);
    try {
      final ocrQueueRepo = ref.read(ocrQueueRepositoryProvider);
      await ocrQueueRepo.enqueue(currentImage.id);
      await BackgroundWorkerService().triggerProcessing();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.detail_ocr_queued)));
      }
      await Future<void>.delayed(const Duration(seconds: 2));
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.detail_ocr_failed(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setupOcrListener() {
    ref.listen(ocrPendingCountProvider, (previous, next) {
      if (next.hasValue && next.value! < (previous?.value ?? 0)) {
        Future.microtask(() {
          if (mounted) _loadData();
        });
      }
    });
  }

  PreferredSizeWidget _buildAppBar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(l10n.detail_title),
      backgroundColor: AppTheme.bgWhite,
      foregroundColor: AppTheme.textPrimary,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.description_outlined),
          tooltip: l10n.detail_ocr_text,
          onPressed: () => _showOCRText(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: _images.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            final img = _images[index];
            return Center(
              child: GestureDetector(
                onTap: () => _showFullImage(index),
                child: SecureImage(
                  imagePath: img.filePath,
                  encryptionKey: img.encryptionKey,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
        if (_images.length > 1) ...[
          if (_currentIndex > 0) _buildNavButton(isLeft: true),
          if (_currentIndex < _images.length - 1)
            _buildNavButton(isLeft: false),
        ],
        _buildPageIndicator(),
      ],
    );
  }

  void _showFullImage(int index) {
    Navigator.push<int>(
      context,
      MaterialPageRoute<int>(
        builder: (context) =>
            FullImageViewer(images: _images, initialIndex: _currentIndex),
      ),
    ).then((newIndex) {
      if (newIndex is int && mounted) _pageController.jumpToPage(newIndex);
    });
  }

  Widget _buildNavButton({required bool isLeft}) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(left: isLeft ? 12 : 0, right: isLeft ? 0 : 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isLeft ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              if (isLeft) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${_currentIndex + 1} / ${_images.length}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoView(MedicalImage img) {
    final l10n = AppLocalizations.of(context)!;
    final hospital = img.hospitalName ?? _record?.hospitalName ?? '';
    final date = img.visitDate ?? _record?.notedAt;
    final dateStr = date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem(l10n.detail_hospital_label, hospital, isTitle: true),
        const SizedBox(height: 16),
        _buildInfoItem(l10n.detail_date_label, dateStr, isMono: true),
        const SizedBox(height: 24),
        Text(
          l10n.detail_tags_label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
        ),
        const SizedBox(height: 8),
        _buildTagList(img),
        const SizedBox(height: 24),
        _buildOcrCard(img),
        const SizedBox(height: 40),
        const Divider(),
        const SizedBox(height: 16),
        _buildActionButtons(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoItem(
    String label,
    String value, {
    bool isTitle = false,
    bool isMono = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
        ),
        Text(
          value,
          style: isMono
              ? AppTheme.monoStyle.copyWith(fontSize: 16)
              : TextStyle(
                  fontSize: 18,
                  fontWeight: isTitle ? FontWeight.bold : null,
                ),
        ),
      ],
    );
  }

  Widget _buildTagList(MedicalImage img) {
    if (img.tagIds.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.detail_no_tags,
        style: const TextStyle(color: AppTheme.textHint, fontSize: 14),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: img.tagIds
          .map<Widget>((tid) => _TagNameChip(tagId: tid))
          .toList(),
    );
  }

  Widget _buildOcrCard(MedicalImage img) {
    OcrResult? ocrResult;
    if (img.ocrRawJson != null) {
      try {
        ocrResult = OcrResult.fromJson(
          jsonDecode(img.ocrRawJson!) as Map<String, dynamic>,
        );
      } catch (_) {}
    }
    return CollapsibleOcrCard(text: img.ocrText ?? '', ocrResult: ocrResult);
  }

  Widget _buildActionButtons() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _enterEditMode,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.detail_edit_page),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _retriggerOCR,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n.detail_retrigger_ocr),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryTeal,
                  side: const BorderSide(color: AppTheme.primaryTeal),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _deleteCurrentImage,
            icon: const Icon(Icons.delete_outline, size: 18),
            label: Text(l10n.detail_delete_page),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
              side: const BorderSide(color: AppTheme.errorRed),
            ),
          ),
        ),
      ],
    );
  }

  void _showOCRText() {
    if (_images.isEmpty) return;
    final img = _images[_currentIndex];
    OcrResult? ocrResult;
    if (img.ocrRawJson != null) {
      try {
        ocrResult = OcrResult.fromJson(
          jsonDecode(img.ocrRawJson!) as Map<String, dynamic>,
        );
      } catch (_) {}
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => _OcrResultSheet(
          text: img.ocrText ?? '',
          result: ocrResult,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _OcrResultSheet extends StatefulWidget {
  final String text;
  final OcrResult? result;
  final ScrollController scrollController;
  const _OcrResultSheet({
    required this.text,
    this.result,
    required this.scrollController,
  });
  @override
  State<_OcrResultSheet> createState() => _OcrResultSheetState();
}

class _OcrResultSheetState extends State<_OcrResultSheet> {
  bool _isEnhanced = true;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.detail_ocr_result,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  if (widget.result != null)
                    TextButton.icon(
                      onPressed: () =>
                          setState(() => _isEnhanced = !_isEnhanced),
                      icon: Icon(
                        _isEnhanced ? Icons.text_fields : Icons.auto_awesome,
                        size: 18,
                      ),
                      label: Text(
                        _isEnhanced
                            ? l10n.detail_view_raw
                            : l10n.detail_view_enhanced,
                      ),
                    ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: widget.result != null
                ? EnhancedOcrView(
                    result: widget.result!,
                    isEnhancedMode: _isEnhanced,
                    scrollController: widget.scrollController,
                  )
                : SingleChildScrollView(
                    controller: widget.scrollController,
                    child: SelectableText(
                      widget.text,
                      style: AppTheme.monoStyle.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check),
              label: Text(l10n.common_confirm),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagNameChip extends ConsumerWidget {
  final String tagId;
  const _TagNameChip({required this.tagId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTagsAsync = ref.watch(allTagsProvider);
    return allTagsAsync.when(
      data: (allTags) {
        final tag = allTags.firstWhere(
          (t) => t.id == tagId,
          orElse: () =>
              Tag(id: '', name: '?', createdAt: DateTime(0), color: ''),
        );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryTeal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryTeal.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            L10nHelper.getTagName(context, tag),
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.primaryTeal,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, _) => const SizedBox(),
    );
  }
}
