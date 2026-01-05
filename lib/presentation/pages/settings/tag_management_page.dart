/// # Tag Management Page
///
/// ## Description
/// 标签管理中心，支持基于人员的标签 CRUD、拖拽排序及级联删除。
/// 遵循 `Constitution#VI. UI/UX` 准则，保持 Teal/White 色调与等宽字体。
///
/// ## Repair Logs
/// - [2026-01-05] 修复：
///   1. 统一标签名称显示为 Monospace 字体，符合 Constitution 规范。
///   2. 补全对话框保存操作的错误捕获与用户提示，避免异常吞没。
///   3. 修正新建标签的 `orderIndex` 逻辑，默认追加至当前人员列表末尾。
///   4. 优化拖拽排序逻辑，使用 `TagRepository.updateOrder` 批量提交。
///
/// ## Features
/// - **Personnel Tabs**: 顶部展示人员切换，自动过滤标签列表。
/// - **Tag List**: 展示当前人员可见的所有标签（含系统内置与自定义）。
/// - **CRUD**:
///   - **Create**: 仅限自定义标签。
///   - **Update**: 重命名自定义标签。
///   - **Delete**: 删除自定义标签，触发级联清理（Repository 处理）。
/// - **Drag-Sort**: 支持拖拽排序，仅影响当前人员的视图。
///
/// ## Security
/// - 数据存储于本地加密数据库，符合 `Constitution#I. Privacy`。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/tag.dart';
import '../../../logic/providers/core_providers.dart';
import '../../../logic/providers/person_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/personnel_tabs.dart';

class TagManagementPage extends ConsumerStatefulWidget {
  const TagManagementPage({super.key});

  @override
  ConsumerState<TagManagementPage> createState() => _TagManagementPageState();
}

class _TagManagementPageState extends ConsumerState<TagManagementPage> {
  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(allTagsProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: const Text('标签库管理'),
        backgroundColor: AppTheme.bgWhite,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          const PersonnelTabs(),
          Expanded(
            child: tagsAsync.when(
              data: (tags) => _buildList(context, tags),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('加载失败: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(),
        backgroundColor: AppTheme.primaryTeal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Tag> tags) {
    if (tags.isEmpty) {
      return const Center(
        child: Text('暂无标签', style: TextStyle(color: AppTheme.textHint)),
      );
    }

    return ReorderableListView.builder(
      itemCount: tags.length,
      padding: const EdgeInsets.only(bottom: 80),
      onReorder: (oldIndex, newIndex) => _onReorder(tags, oldIndex, newIndex),
      itemBuilder: (context, index) {
        final tag = tags[index];
        return _buildItem(context, tag, index);
      },
    );
  }

  Widget _buildItem(BuildContext context, Tag tag, int index) {
    return Container(
      key: ValueKey(tag.id),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.bgGrey)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(int.parse(tag.color.replaceAll('#', '0xFF'))),
          radius: 12,
        ),
        title: Text(
          tag.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            fontFamily: AppTheme.fontPool,
          ),
        ),
        subtitle: Text(
          tag.isCustom ? '自定义标签' : '系统内置',
          style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tag.isCustom) ...[
              IconButton(
                icon: const Icon(Icons.edit, color: AppTheme.textHint),
                onPressed: () => _showEditDialog(tag: tag),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: AppTheme.textHint),
                onPressed: () => _confirmDelete(tag),
              ),
            ],
            const SizedBox(width: 8),
            const Icon(Icons.drag_handle, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }

  Future<void> _onReorder(List<Tag> tags, int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = tags.removeAt(oldIndex);
    tags.insert(newIndex, item);

    try {
      final repo = ref.read(tagRepositoryProvider);
      await repo.updateOrder(tags);
      ref.invalidate(allTagsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('排序失败: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(Tag tag) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除标签'),
        content: Text('确定要删除标签 "${tag.name}" 吗？此操作会从所有关联的图片中移除该标签。'),
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

    if (confirm == true) {
      try {
        await ref.read(tagRepositoryProvider).deleteTag(tag.id);
        ref.invalidate(allTagsProvider);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('删除成功')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('删除失败: $e'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    }
  }

  Future<void> _showEditDialog({Tag? tag}) async {
    final isEditing = tag != null;
    final nameCtrl = TextEditingController(text: tag?.name ?? '');

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? '编辑标签' : '新建标签'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: '标签名称',
            hintText: '例：化验单、胸透',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;

              try {
                final repo = ref.read(tagRepositoryProvider);
                if (isEditing) {
                  await repo.updateTag(tag.copyWith(name: name));
                } else {
                  final currentTags = ref.read(allTagsProvider).value ?? [];
                  final personId = await ref.read(
                    currentPersonIdControllerProvider.future,
                  );
                  final newTag = Tag(
                    id: const Uuid().v4(),
                    name: name,
                    color: '#008080', // Default Teal
                    personId: personId,
                    isCustom: true,
                    orderIndex: currentTags.length,
                    createdAt: DateTime.now(),
                  );
                  await repo.createTag(newTag);
                }
                ref.invalidate(allTagsProvider);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('保存失败: $e'),
                      backgroundColor: AppTheme.errorRed,
                    ),
                  );
                }
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
