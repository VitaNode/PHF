/// # TagSelector Component
///
/// ## Description
/// 标签选择与排序组件，支持搜索、创建、高亮选中以及拖拽排序。
///
/// ## Repair Logs
/// - [2026-01-05] 修复：
///   1. 修正 `FilterChip` 圆角为 8px 以符合 UI/UX 规范 (Unified 8px)。
///   2. 为 `onCreate` 操作添加 try-catch 异常捕获与 SnackBar 提示，增强健壮性。
///
/// ## Core Components
/// - **Search & Create**: 支持按名称搜索标签，若不存在则提示创建。
/// - **Quick Selection**: 展示过滤后的标签库。
/// - **Reorderable List**: 展示已选标签并支持通过拖拽手柄改变其展示优先级。
///
/// ## Parameters
/// - `selectedTagIds`: 当前已选中的标签 ID 列表。
/// - `onToggle`: 切换某个标签选中状态的回调函数。
/// - `onReorder`: 拖拽排序完成后的回调函数。
/// - `onCreate`: 创建新标签的回调函数。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import '../../logic/providers/core_providers.dart';
import '../../data/models/tag.dart';
import '../theme/app_theme.dart';
import '../utils/l10n_helper.dart';

class TagSelector extends ConsumerStatefulWidget {
  final List<String> selectedTagIds;
  final void Function(String) onToggle;
  final void Function(int, int) onReorder;
  final Future<void> Function(String name)? onCreate;

  const TagSelector({
    super.key,
    required this.selectedTagIds,
    required this.onToggle,
    required this.onReorder,
    this.onCreate,
  });

  @override
  ConsumerState<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends ConsumerState<TagSelector> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTagsAsync = ref.watch(allTagsProvider);
    final l10n = AppLocalizations.of(context)!;
    return allTagsAsync.when(
      data: (allTags) => _buildContent(context, allTags),
      loading: () => const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          l10n.common_load_failed(err.toString()),
          style: const TextStyle(color: AppTheme.errorRed, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Tag> allTags) {
    final l10n = AppLocalizations.of(context)!;
    final filteredTags = _filterTags(allTags);
    final bool hasExactMatch = _checkExactMatch(allTags);
    final bool showCreateOption =
        _searchQuery.isNotEmpty && !hasExactMatch && widget.onCreate != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchField(l10n),
        const SizedBox(height: 12),
        if (showCreateOption) _buildCreateOption(context, l10n),
        if (filteredTags.isNotEmpty) ...[
          _buildTagsWrap(filteredTags),
          const SizedBox(height: 24),
        ],
        if (widget.selectedTagIds.isNotEmpty) ...[
          const Divider(),
          const SizedBox(height: 8),
          _buildReorderHeader(),
          const SizedBox(height: 8),
          _buildReorderList(allTags, l10n),
        ],
      ],
    );
  }

  List<Tag> _filterTags(List<Tag> allTags) {
    return allTags.where((tag) {
      if (_searchQuery.isEmpty) return true;
      final localizedName = L10nHelper.getTagName(context, tag);
      return localizedName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tag.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  bool _checkExactMatch(List<Tag> allTags) {
    return allTags.any((t) {
      final localizedMatch =
          L10nHelper.getTagName(context, t).toLowerCase() ==
          _searchQuery.toLowerCase().trim();
      final rawMatch =
          t.name.toLowerCase() == _searchQuery.toLowerCase().trim();
      return localizedMatch || rawMatch;
    });
  }

  Widget _buildSearchField(AppLocalizations l10n) {
    return TextField(
      controller: _searchCtrl,
      decoration: InputDecoration(
        hintText: l10n.tag_field_name_hint,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  _searchCtrl.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.bgGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.bgGrey),
        ),
      ),
      onChanged: (val) {
        setState(() => _searchQuery = val);
      },
    );
  }

  Widget _buildCreateOption(BuildContext context, AppLocalizations l10n) {
    return InkWell(
      onTap: () async {
        final newName = _searchQuery.trim();
        if (newName.isEmpty) return;
        try {
          await widget.onCreate?.call(newName);
          _searchCtrl.clear();
          setState(() => _searchQuery = '');
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.common_load_failed(e.toString())),
                backgroundColor: AppTheme.errorRed,
              ),
            );
          }
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryTeal.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.primaryTeal.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: AppTheme.primaryTeal,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.tag_create_new(_searchQuery),
              style: const TextStyle(
                color: AppTheme.primaryTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsWrap(List<Tag> filteredTags) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: filteredTags.map((tag) {
        final isSelected = widget.selectedTagIds.contains(tag.id);
        return FilterChip(
          label: Text(L10nHelper.getTagName(context, tag)),
          selected: isSelected,
          onSelected: (_) => widget.onToggle(tag.id),
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
            borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _buildReorderHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        const Icon(Icons.swap_vert, size: 16, color: AppTheme.textHint),
        const SizedBox(width: 4),
        Text(
          l10n.tag_reorder_title,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textHint,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildReorderList(List<Tag> allTags, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.bgGrey),
      ),
      child: ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onReorder: widget.onReorder,
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
          for (int i = 0; i < widget.selectedTagIds.length; i++)
            _buildReorderItem(allTags, widget.selectedTagIds[i], i, l10n),
        ],
      ),
    );
  }

  Widget _buildReorderItem(
    List<Tag> allTags,
    String id,
    int index,
    AppLocalizations l10n,
  ) {
    final tag = allTags.firstWhere(
      (t) => t.id == id,
      orElse: () => Tag(id: id, name: '?', createdAt: DateTime(0), color: ''),
    );
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          L10nHelper.getTagName(context, tag),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.remove_circle_outline,
            color: AppTheme.textHint,
            size: 20,
          ),
          onPressed: () => widget.onToggle(id),
          tooltip: l10n.common_delete,
        ),
      ),
    );
  }
}
