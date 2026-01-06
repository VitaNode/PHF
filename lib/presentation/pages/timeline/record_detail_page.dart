/// # Record Detail Page
///
/// ## Description
/// 展示病历详情，支持图片轮播、OCR 结果查看及编辑。
///
/// ## Repair Logs
/// - [2025-12-31] 修复：自动刷新数据后，保持当前的图片索引（原先会跳回第 0 张）；优化 OCR 监听逻辑，支持中间任务状态更新刷新；修复 Future.delayed 类型推导。
/// - [2025-12-31] T21.4 详情页编辑闭环：优化保存逻辑，确保标签修改和元数据更新后立即同步 Timeline 状态；增加保存前的数据变更检查，避免无效更新。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
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

  // Edit controllers
  late TextEditingController _hospitalController;
  DateTime? _visitDate;

  @override
  void initState() {
    super.initState();
    _hospitalController = TextEditingController();
    _pageController = PageController();
    _loadData();
  }

  @override
  void dispose() {
    _hospitalController.dispose();
    _pageController.dispose();
    super.dispose();
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
          // Sync controllers with current image
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
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      if (!_isEditing) {
        _updateControllersForIndex(index);
      }
    });
  }

  Future<void> _saveChanges() async {
    if (_images.isEmpty) return;

    final currentImage = _images[_currentIndex];

    // Check if anything actually changed
    final bool hospitalChanged =
        _hospitalController.text !=
        (currentImage.hospitalName ?? _record?.hospitalName ?? '');
    final bool dateChanged =
        _visitDate != (currentImage.visitDate ?? _record?.notedAt);

    if (!hospitalChanged && !dateChanged) {
      setState(() => _isEditing = false);
      return;
    }

    final imageRepo = ref.read(imageRepositoryProvider);
    final recordRepo = ref.read(recordRepositoryProvider);

    try {
      // 1. Update Image specific metadata
      await imageRepo.updateImageMetadata(
        currentImage.id,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );

      // 2. Also update Record metadata (User might expect global change)
      await recordRepo.updateRecordMetadata(
        widget.recordId,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );

      // 3. Reload everything to ensure consistency
      await _loadData();

      setState(() {
        _isEditing = false;
      });

      // Notify Timeline to refresh
      await ref.read(timelineControllerProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('保存成功')));
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

      // If it was the last image, go back
      if (_images.length == 1) {
        if (mounted) Navigator.pop(context);
        return;
      }

      // Notify Timeline to refresh
      ref.invalidate(timelineControllerProvider);

      // Reload
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

      // 1. Enqueue
      await ocrQueueRepo.enqueue(currentImage.id);

      // 2. Trigger Background Worker
      await BackgroundWorkerService().triggerProcessing();

      // 3. Start foreground processing (Immediate feedback)
      // ignore: unawaited_futures
      BackgroundWorkerService().startForegroundProcessing(
        talker: ref.read(talkerProvider),
      );

      // We don't wait for completion here, but we should inform the user
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('已重新加入识别队列，请稍候...')));
      }

      // Wait a bit and reload to see if it finished (simple UX)
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
      color: '#009688', // Default teal
      createdAt: DateTime.now(),
      isCustom: true,
    );

    try {
      await tagRepo.createTag(newTag);

      // Refresh tags list so TagSelector sees it
      ref.invalidate(allTagsProvider);

      // Add to current image
      final currentIds = [..._images[_currentIndex].tagIds, newTag.id];
      setState(() {
        _images[_currentIndex] = _images[_currentIndex].copyWith(
          tagIds: currentIds,
        );
      });

      await ref
          .read(imageRepositoryProvider)
          .updateImageTags(_images[_currentIndex].id, currentIds);

      // Notify Timeline
      await ref.read(timelineControllerProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('已创建标签 "${newTag.name}"')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('创建标签失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听 OCR 任务，如果识别进度有更新，自动刷新数据
    ref.listen(ocrPendingCountProvider, (previous, next) {
      if (next.hasValue) {
        final prevCount = previous?.value ?? 0;
        final nextCount = next.value!;

        // 只要任务在减少（哪怕没归零，也可能当前看的那张图好了）
        if (nextCount < prevCount || (prevCount > 0 && nextCount == 0)) {
          ref
              .read(talkerProvider)
              .info('[RecordDetailPage] OCR update detected. Reloading data.');
          _loadData();
        }
      }
    });

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_record == null || _images.isEmpty) {
      return const Scaffold(body: Center(child: Text('记录不存在')));
    }

    final currentImage = _images[_currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: Text(_isEditing ? '编辑详情' : '病历详情'),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _saveChanges,
              child: const Text(
                '保存',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.description_outlined),
            tooltip: '查看识别文本',
            onPressed: () => _showOCRText(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _images.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final img = _images[index];
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push<int>(
                            context,
                            MaterialPageRoute<int>(
                              builder: (context) => FullImageViewer(
                                images: _images,
                                initialIndex: _currentIndex,
                              ),
                            ),
                          ).then((newIndex) {
                            if (newIndex is int && mounted) {
                              _pageController.jumpToPage(newIndex);
                            }
                          });
                        },
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
                  if (_currentIndex > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  if (_currentIndex < _images.length - 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${_images.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 2. Bottom Section - Details
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _isEditing
                  ? _buildEditView()
                  : _buildInfoView(currentImage),
            ),
          ),
        ],
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
        const Text(
          '医院',
          style: TextStyle(fontSize: 12, color: AppTheme.textHint),
        ),
        Text(
          hospital,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          '就诊日期',
          style: TextStyle(fontSize: 12, color: AppTheme.textHint),
        ),
        Text(dateStr, style: AppTheme.monoStyle.copyWith(fontSize: 16)),
        const SizedBox(height: 24),
        const Text(
          '标签',
          style: TextStyle(fontSize: 12, color: AppTheme.textHint),
        ),
        const SizedBox(height: 8),
        if (img.tagIds.isEmpty)
          const Text(
            '无标签',
            style: TextStyle(color: AppTheme.textHint, fontSize: 14),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: img.tagIds
                .map<Widget>((tid) => _TagNameChip(tagId: tid))
                .toList(),
          ),
        const SizedBox(height: 24),
        Builder(
          builder: (context) {
            OcrResult? ocrResult;
            if (img.ocrRawJson != null) {
              try {
                ocrResult = OcrResult.fromJson(
                  jsonDecode(img.ocrRawJson!) as Map<String, dynamic>,
                );
              } catch (_) {}
            }
            return CollapsibleOcrCard(
              text: img.ocrText ?? '',
              ocrResult: ocrResult,
            );
          },
        ),
        const SizedBox(height: 40),
        const Divider(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _isEditing = true),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('编辑此页'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _retriggerOCR,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('重新识别'),
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
            label: const Text('删除此页'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
              side: const BorderSide(color: AppTheme.errorRed),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEditView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _hospitalController,
          decoration: const InputDecoration(labelText: '医院名称'),
        ),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('就诊日期'),
          subtitle: Text(
            _visitDate != null
                ? DateFormat('yyyy-MM-dd').format(_visitDate!)
                : '选择日期',
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _visitDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) setState(() => _visitDate = picked);
          },
        ),
        const SizedBox(height: 24),
        const Text('管理标签', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TagSelector(
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
              // Notify Timeline (async)
              await ref.read(timelineControllerProvider.notifier).refresh();
            } catch (e) {
              setState(() {
                _images[_currentIndex] = _images[_currentIndex].copyWith(
                  tagIds: oldIds,
                );
              });
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('更新标签失败: $e')));
              }
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
              // Notify Timeline (async)
              await ref.read(timelineControllerProvider.notifier).refresh();
            } catch (e) {
              setState(() {
                _images[_currentIndex] = _images[_currentIndex].copyWith(
                  tagIds: originalIds,
                );
              });
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('重排标签失败: $e')));
              }
            }
          },
          onCreate: _handleCreateTag,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              setState(() {
                _isEditing = false;
                _updateControllersForIndex(_currentIndex);
              });
            },
            child: const Text(
              '取消编辑',
              style: TextStyle(color: AppTheme.textGrey),
            ),
          ),
        ),
        const SizedBox(height: 24),
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
              const Text(
                'OCR 识别结果',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      label: Text(_isEnhanced ? '查看原文' : '智能增强'),
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
