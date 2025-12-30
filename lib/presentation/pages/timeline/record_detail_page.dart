import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/image.dart';
import '../../../data/models/record.dart';
import '../../../data/models/tag.dart';
import '../../../logic/providers/core_providers.dart';
import '../../../logic/providers/timeline_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/secure_image.dart';
import '../../widgets/tag_selector.dart';
import '../../widgets/full_image_viewer.dart';

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
          // Sync controllers with first image or record
          if (_images.isNotEmpty) {
            _updateControllersForIndex(0);
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
    final imageRepo = ref.read(imageRepositoryProvider);
    
    try {
      await imageRepo.updateImageMetadata(
        currentImage.id,
        hospitalName: _hospitalController.text,
        visitDate: _visitDate,
      );
      
      // Update local state
      setState(() {
        _images[_currentIndex] = currentImage.copyWith(
          hospitalName: _hospitalController.text,
          visitDate: _visitDate,
        );
        _isEditing = false;
      });

      // Notify Timeline to refresh
      ref.invalidate(timelineControllerProvider);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('保存成功')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('保存失败: $e')));
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
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('删除')
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
        Navigator.pop(context);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('删除失败: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_record == null || _images.isEmpty) return const Scaffold(body: Center(child: Text('记录不存在')));

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
              child: const Text('保存', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ... (existing Image Pager code remains the same)
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
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.black54, size: 40),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  if (_currentIndex < _images.length - 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.chevron_right, color: Colors.black54, size: 40),
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                ],
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${_images.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
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
              child: _isEditing ? _buildEditView() : _buildInfoView(currentImage),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoView(MedicalImage img) {
    final hospital = img.hospitalName ?? _record?.hospitalName ?? '未填写';
    final date = img.visitDate ?? _record?.notedAt;
    final dateStr = date != null ? DateFormat('yyyy-MM-dd').format(date) : '未知日期';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('医院', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
        Text(hospital, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        
        const SizedBox(height: 16),
        
        const Text('就诊日期', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
        Text(dateStr, style: AppTheme.monoStyle.copyWith(fontSize: 16)),
        
        const SizedBox(height: 24),
        
        const Text('标签', style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
        const SizedBox(height: 8),
        if (img.tagIds.isEmpty)
          const Text('无标签', style: TextStyle(color: AppTheme.textHint, fontSize: 14))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: img.tagIds.map((tid) => _TagNameChip(tagId: tid)).toList(),
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
                onPressed: _deleteCurrentImage,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('删除此页'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorRed,
                  side: const BorderSide(color: AppTheme.errorRed),
                ),
              ),
            ),
          ],
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
          subtitle: Text(_visitDate != null ? DateFormat('yyyy-MM-dd').format(_visitDate!) : '选择日期'),
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
          onToggle: (tid) {
            final currentIds = [..._images[_currentIndex].tagIds];
            if (currentIds.contains(tid)) {
              currentIds.remove(tid);
            } else {
              currentIds.add(tid);
            }
            setState(() {
              _images[_currentIndex] = _images[_currentIndex].copyWith(tagIds: currentIds);
            });
            ref.read(imageRepositoryProvider).updateImageTags(
              _images[_currentIndex].id, 
              currentIds
            );
          },
          onReorder: (oldIdx, newIdx) {
            final currentIds = [..._images[_currentIndex].tagIds];
            if (oldIdx < newIdx) newIdx -= 1;
            final item = currentIds.removeAt(oldIdx);
            currentIds.insert(newIdx, item);
            setState(() {
              _images[_currentIndex] = _images[_currentIndex].copyWith(tagIds: currentIds);
            });
            ref.read(imageRepositoryProvider).updateImageTags(
              _images[_currentIndex].id, 
              currentIds
            );
          },
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
            child: const Text('取消编辑', style: TextStyle(color: AppTheme.textGrey)),
          ),
        ),
        const SizedBox(height: 24),
      ],
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
                    final tag = allTags.firstWhere((t) => t.id == tagId, orElse: () => Tag(id: '', name: '?', createdAt: DateTime(0), color: ''));
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryTeal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.primaryTeal.withValues(alpha: 0.2)),
                      ),
                      child: Text(tag.name, style: const TextStyle(fontSize: 12, color: AppTheme.primaryTeal, fontWeight: FontWeight.bold)),
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                );
              }
            }