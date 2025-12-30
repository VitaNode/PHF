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
    final selectedTags = selectedTagIds
        .map((id) => allTags.firstWhere((t) => t.id == id,
            orElse: () => Tag(
                id: id,
                name: 'Unknown',
                createdAt: DateTime.now(),
                color: '#888888')))
        .toList();

    final unselectedTags =
        allTags.where((t) => !selectedTagIds.contains(t.id)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedTags.isNotEmpty) ...[
          const Text('已选标签 (拖动排序)',
              style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
          const SizedBox(height: 8),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: onReorder,
            children: [
              for (final tag in selectedTags)
                ListTile(
                  key: ValueKey(tag.id),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.label, color: AppTheme.primaryTeal),
                  title: Text(tag.name, style: const TextStyle(fontSize: 14)),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: AppTheme.errorRed, size: 20),
                    onPressed: () => onToggle(tag.id),
                  ),
                ),
            ],
          ),
          const Divider(),
        ],
        if (unselectedTags.isNotEmpty) ...[
          const Text('可用标签',
              style: TextStyle(fontSize: 12, color: AppTheme.textHint)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: unselectedTags.map((tag) {
              return ActionChip(
                label: Text(tag.name),
                labelStyle: const TextStyle(fontSize: 12),
                backgroundColor: AppTheme.bgGray,
                onPressed: () => onToggle(tag.id),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}