/// # Record Detail Page
///
/// ## Description
/// 展示病历详情，支持图片轮播、OCR 结果查看及增强型结构化编辑模式。
///
/// ## Features (Phase 4)
/// - **Sticky Magnifier**: 编辑模式下，预览浮层固定在顶部，不随内容滚动。
/// - **Immersive Edit Mode**: 编辑时隐藏原图大窗口，腾出全屏空间进行逐行校对。
/// - **Precise Targeting**: 点击不同字段，预览区精准对焦。
library;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:phf/presentation/widgets/focus_zoom_overlay.dart';
import 'package:phf/logic/services/slm/layout_parser.dart';
import 'package:phf/data/models/slm/slm_data_block.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/image.dart';
import '../../../data/models/ocr_result.dart';
import '../../../data/models/record.dart';
import '../../../data/models/tag.dart';
import '../../../logic/providers/core_providers.dart';
import '../../../logic/providers/timeline_provider.dart';
import '../../../logic/providers/logging_provider.dart';
import '../../../logic/providers/ocr_status_provider.dart';
import '../../../logic/providers/person_provider.dart';
import '../../../logic/services/background_worker_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/secure_image.dart';
import '../../widgets/tag_selector.dart';
import '../../widgets/full_image_viewer.dart';
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
  bool _isEditing = false;
  late PageController _pageController;

  // Edit controllers & focus nodes
  late TextEditingController _hospitalController;
  final FocusNode _hospitalFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();
  DateTime? _visitDate;

  // Structured data blocks
  List<SLMDataBlock> _currentBlocks = [];
  final List<TextEditingController> _blockControllers = [];
  final List<FocusNode> _blockFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _hospitalController = TextEditingController();
    _pageController = PageController();
    _hospitalFocus.addListener(() => setState(() {}));
    _dateFocus.addListener(() => setState(() {}));
    _loadData();
  }

  @override
  void dispose() {
    _hospitalController.dispose();
    _hospitalFocus.dispose();
    _dateFocus.dispose();
    _disposeBlockResources();
    _pageController.dispose();
    super.dispose();
  }

  void _disposeBlockResources() {
    for (final c in _blockControllers) {
      c.dispose();
    }
    for (final f in _blockFocusNodes) {
      f.dispose();
    }
    _blockControllers.clear();
    _blockFocusNodes.clear();
  }

  @override
  Widget build(BuildContext context) {
    _setupOcrListener();

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_record == null || _images.isEmpty) {
      return const Scaffold(body: Center(child: Text('记录不存在')));
    }

    final currentImage = _images[_currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: _buildAppBar(),
      body: _isEditing
          ? _buildImmersiveEditView(currentImage)
          : _buildStandardDetailView(currentImage),
    );
  }

  Widget _buildStandardDetailView(MedicalImage currentImage) {
    return Column(
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
    );
  }

  Widget _buildImmersiveEditView(MedicalImage currentImage) {
    final l10n = AppLocalizations.of(context)!;
    final isLowConfidence =
        currentImage.ocrConfidence != null && currentImage.ocrConfidence! < 0.8;
    final warningColor = Colors.orange.shade50;

    return Column(
      children: [
        _buildMagnifier(currentImage),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.review_edit_basic_info,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _hospitalController,
                  focusNode: _hospitalFocus,
                  decoration: InputDecoration(
                    labelText: l10n.review_edit_hospital_label,
                    border: const OutlineInputBorder(),
                    filled: isLowConfidence,
                    fillColor: isLowConfidence ? warningColor : null,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDatePicker(currentImage, isLowConfidence, warningColor),

                const SizedBox(height: 32),
                if (_blockControllers.isNotEmpty) ...[
                  const Text(
                    '识别内容 (可点击逐行校对)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '点击下方文字，上方将自动放大对应图片区域',
                    style: TextStyle(fontSize: 11, color: AppTheme.textHint),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _blockControllers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final block = _currentBlocks[index];
                      final isBlockLow = block.confidence < 0.8;
                      return TextField(
                        controller: _blockControllers[index],
                        focusNode: _blockFocusNodes[index],
                        maxLines: null,
                        style: AppTheme.monoStyle.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          filled: isBlockLow,
                          fillColor: isBlockLow
                              ? warningColor
                              : Colors.grey.shade50,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          isDense: true,
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 32),
                const Text(
                  '管理标签',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildTagSelector(),
                const SizedBox(height: 32),
                _buildCancelEditButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMagnifier(MedicalImage currentImage) {
    List<double>? rect;
    if (_hospitalFocus.hasFocus) {
      rect = LayoutParser().findFieldCoordinates(_currentBlocks, 'hospital');
    } else if (_dateFocus.hasFocus) {
      rect = LayoutParser().findFieldCoordinates(_currentBlocks, 'date');
    } else {
      final idx = _blockFocusNodes.indexWhere((f) => f.hasFocus);
      if (idx != -1) rect = _currentBlocks[idx].boundingBox;
    }

    if (rect == null) return const SizedBox.shrink();

    return Container(
      height: 160,
      width: double.infinity,
      color: Colors.black,
      child: FocusZoomOverlay(
        imagePath: currentImage.filePath,
        encryptionKey: currentImage.encryptionKey,
        normalizedRect: rect,
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
          if (_images.isNotEmpty) {
            final index = _currentIndex < _images.length ? _currentIndex : 0;
            _updateControllersForIndex(index);
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _updateControllersForIndex(int index) {
    final img = _images[index];
    _hospitalController.text = img.hospitalName ?? _record?.hospitalName ?? '';
    _visitDate = img.visitDate ?? _record?.notedAt;

    _disposeBlockResources();
    OcrResult? ocr;
    if (img.ocrRawJson != null) {
      try {
        ocr = OcrResult.fromJson(
          jsonDecode(img.ocrRawJson!) as Map<String, dynamic>,
        );
      } catch (_) {}
    }

    if (ocr != null) {
      _currentBlocks = LayoutParser().parse(ocr);
      for (final block in _currentBlocks) {
        final controller = TextEditingController(text: block.rawText);
        final focusNode = FocusNode();
        focusNode.addListener(() => setState(() {}));
        _blockControllers.add(controller);
        _blockFocusNodes.add(focusNode);
      }
    } else {
      _currentBlocks = [];
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _updateControllersForIndex(index);
    });
  }

  Future<void> _saveChanges() async {
    if (_images.isEmpty) return;
    final currentImage = _images[_currentIndex];

    final imageRepo = ref.read(imageRepositoryProvider);
    final recordRepo = ref.read(recordRepositoryProvider);

    try {
      if (_blockControllers.isNotEmpty) {
        final newFullText = _blockControllers.map((c) => c.text).join('\n');
        await imageRepo.updateOCRData(currentImage.id, newFullText);
      }

      await imageRepo.updateImageMetadata(
        currentImage.id,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );

      await recordRepo.updateRecordMetadata(
        widget.recordId,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );

      await _loadData();
      setState(() => _isEditing = false);
      await ref.read(timelineControllerProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.common_save)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    }
  }

  Future<void> _deleteCurrentImage() async {
    if (_images.isEmpty) return;
    final currentImage = _images[_currentIndex];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除确认'),
        content: const Text('确定要删除当前这张图片吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('删除'),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
      }
    }
  }

  Future<void> _retriggerOCR() async {
    if (_images.isEmpty) return;
    final currentImage = _images[_currentIndex];
    setState(() => _isLoading = true);
    try {
      final ocrQueueRepo = ref.read(ocrQueueRepositoryProvider);
      await ocrQueueRepo.enqueue(currentImage.id);
      await BackgroundWorkerService().triggerProcessing();
      unawaited(
        BackgroundWorkerService().startForegroundProcessing(
          talker: ref.read(talkerProvider),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('已重新加入识别队列，请稍候...')));
      }
      await Future<void>.delayed(const Duration(seconds: 2));
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('重新识别失败: $e')));
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCreateTag(String name) async {
    final tagRepo = ref.read(tagRepositoryProvider);
    final personId = await ref.read(currentPersonIdControllerProvider.future);
    final newTag = Tag(
      id: const Uuid().v4(),
      name: name,
      personId: personId,
      color: '#009688',
      createdAt: DateTime.now(),
      isCustom: true,
    );
    try {
      await tagRepo.createTag(newTag);
      ref.invalidate(allTagsProvider);
      final currentIds = [..._images[_currentIndex].tagIds, newTag.id];
      setState(() {
        _images[_currentIndex] = _images[_currentIndex].copyWith(
          tagIds: currentIds,
        );
      });
      await ref
          .read(imageRepositoryProvider)
          .updateImageTags(_images[_currentIndex].id, currentIds);
      await ref.read(timelineControllerProvider.notifier).refresh();
    } catch (_) {}
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
      title: Text(_isEditing ? l10n.detail_edit_title : l10n.detail_title),
      backgroundColor: AppTheme.bgWhite,
      foregroundColor: AppTheme.textPrimary,
      elevation: 0,
      actions: [
        if (_isEditing)
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              l10n.detail_save,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
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
    final hospital = img.hospitalName ?? _record?.hospitalName ?? '未填写';
    final date = img.visitDate ?? _record?.notedAt;
    final dateStr = date != null
        ? DateFormat('yyyy-MM-dd').format(date)
        : '未知日期';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem('医院', hospital, isTitle: true),
        const SizedBox(height: 16),
        _buildInfoItem('就诊日期', dateStr, isMono: true),
        const SizedBox(height: 24),
        const Text(
          '标签',
          style: TextStyle(fontSize: 12, color: AppTheme.textHint),
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
    if (img.tagIds.isEmpty)
      return const Text(
        '无标签',
        style: TextStyle(color: AppTheme.textHint, fontSize: 14),
      );
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
                onPressed: () => setState(() => _isEditing = true),
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

  Widget _buildDatePicker(MedicalImage img, bool isLow, Color? warnColor) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () async {
        _dateFocus.requestFocus();
        final picked = await showDatePicker(
          context: context,
          initialDate: _visitDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => _visitDate = picked);
      },
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
            text: _visitDate != null
                ? DateFormat('yyyy-MM-dd').format(_visitDate!)
                : '',
          ),
          focusNode: _dateFocus,
          decoration: InputDecoration(
            labelText: l10n.review_edit_date_label,
            filled: isLow,
            fillColor: isLow ? warnColor : null,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Widget _buildTagSelector() {
    return TagSelector(
      selectedTagIds: _images[_currentIndex].tagIds,
      onToggle: (tid) async {
        final currentIds = [..._images[_currentIndex].tagIds];
        if (currentIds.contains(tid)) {
          currentIds.remove(tid);
        } else {
          currentIds.add(tid);
        }
        final oldIds = _images[_currentIndex].tagIds;
        setState(() {
          _images[_currentIndex] = _images[_currentIndex].copyWith(
            tagIds: currentIds,
          );
        });
        try {
          await ref
              .read(imageRepositoryProvider)
              .updateImageTags(_images[_currentIndex].id, currentIds);
          await ref.read(timelineControllerProvider.notifier).refresh();
        } catch (e) {
          setState(() {
            _images[_currentIndex] = _images[_currentIndex].copyWith(
              tagIds: oldIds,
            );
          });
        }
      },
      onReorder: (oldIdx, newIdx) async {
        final originalIds = [..._images[_currentIndex].tagIds];
        final currentIds = [...originalIds];
        if (oldIdx < newIdx) newIdx -= 1;
        final item = currentIds.removeAt(oldIdx);
        currentIds.insert(newIdx, item);
        setState(() {
          _images[_currentIndex] = _images[_currentIndex].copyWith(
            tagIds: currentIds,
          );
        });
        try {
          await ref
              .read(imageRepositoryProvider)
              .updateImageTags(_images[_currentIndex].id, currentIds);
          await ref.read(timelineControllerProvider.notifier).refresh();
        } catch (e) {
          setState(() {
            _images[_currentIndex] = _images[_currentIndex].copyWith(
              tagIds: originalIds,
            );
          });
        }
      },
      onCreate: _handleCreateTag,
    );
  }

  Widget _buildCancelEditButton() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          setState(() {
            _isEditing = false;
            _updateControllersForIndex(_currentIndex);
          });
        },
        child: Text(
          l10n.detail_cancel_edit,
          style: const TextStyle(color: AppTheme.textGrey),
        ),
      ),
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
              label: const Text('完成'),
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
            tag.name,
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
