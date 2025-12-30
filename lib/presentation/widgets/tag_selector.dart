/// # TagSelector Component
///
/// ## Description
/// 标签选择与排序组件，支持单击高亮切换选中状态以及拖拽排序。
///
/// ## Core Components
/// - **All Tags Library**: 展示全量标签库，支持多选。
/// - **Reorderable List**: 展示已选标签并支持通过拖拽手柄改变其展示优先级。
///
/// ## Parameters
/// - `selectedTagIds`: 当前已选中的标签 ID 列表。
/// - `onToggle`: 切换某个标签选中状态的回调函数。
/// - `onReorder`: 拖拽排序完成后的回调函数，接收 `oldIndex` 和 `newIndex`。
///
/// ## Security & Privacy
/// - **In-Memory Selection**: 标签选择状态在 UI 层即时响应，持久化由 Repository 层通过 SQLCipher 加密数据库处理。
/// - **Data Integrity**: 通过 `TagRepository` 确保关联关系的原子性更新。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/providers/core_providers.dart';
import '../../data/models/tag.dart';
import '../theme/app_theme.dart';

class TagSelector extends ConsumerWidget {
  final List<String> selectedTagIds;
  final Function(String) onToggle;
  final Function(int, int) onReorder;

  const TagSelector({
    super.key,
    required this.selectedTagIds,
    required this.onToggle,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTagsAsync = ref.watch(allTagsProvider);

    return allTagsAsync.when(
      data: (allTags) => _buildContent(context, allTags),
      loading: () => const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('加载标签失败: $err',
            style: const TextStyle(color: AppTheme.errorRed, fontSize: 12)),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Tag> allTags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. All Tags Library (The Selection Area)
        const Text('全量标签 (点击切换选中)', 
            style: TextStyle(fontSize: 12, color: AppTheme.textHint, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: allTags.map((tag) {
            final isSelected = selectedTagIds.contains(tag.id);
            return FilterChip(
              label: Text(tag.name),
              selected: isSelected,
              onSelected: (_) => onToggle(tag.id),
              showCheckmark: true,
              selectedColor: AppTheme.primaryTeal,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryTeal : AppTheme.bgGrey,
                  width: 1,
                ),
              ),
              backgroundColor: AppTheme.bgGrey,
              elevation: isSelected ? 2 : 0,
              pressElevation: 4,
            );
          }).toList(),
        ),

        if (selectedTagIds.isNotEmpty) ...[
          const SizedBox(height: 32),
          Row(
            children: [
              const Icon(Icons.swap_vert, size: 16, color: AppTheme.textHint),
              const SizedBox(width: 4),
              const Text('拖拽排序 (决定展示优先级)', 
                  style: TextStyle(fontSize: 12, color: AppTheme.textHint, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${selectedTagIds.length} 个已选', 
                  style: const TextStyle(fontSize: 11, color: AppTheme.primaryTeal)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.bgGrey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.bgGrey),
            ),
            child: ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: onReorder,
              padding: const EdgeInsets.symmetric(vertical: 8),
              proxyDecorator: (child, index, animation) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: child,
                  ),
                );
              },
              children: [
                for (int i = 0; i < selectedTagIds.length; i++)
                  _buildReorderItem(allTags, selectedTagIds[i], i),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReorderItem(List<Tag> allTags, String id, int index) {
    final tag = allTags.firstWhere((t) => t.id == id, orElse: () => Tag(id: id, name: '?', createdAt: DateTime(0), color: ''));
    return Container(
      key: ValueKey('reorder_$id'),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.bgGrey),
      ),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppTheme.primaryTeal,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(tag.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.drag_handle, color: AppTheme.textHint, size: 20),
      ),
    );
  }
}