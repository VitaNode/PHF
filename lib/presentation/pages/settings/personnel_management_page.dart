/// # Personnel Management Page
///
/// ## Description
/// 人员管理页面，支持 CRUD 操作、拖拽排序及约束删除。
///
/// ## Repair Logs
/// - [2026-01-05] 修复：
///   1. 统一 Nickname 显示为 Monospace 字体，符合 Constitution 规范。
///   2. 补全 Dialog 保存操作的错误捕获与用户提示，避免异常吞没。
///   3. 修正新建人员的 `orderIndex` 逻辑，默认追加至列表末尾。
///   4. 统一错误提示 SnackBar 的背景色为 `AppTheme.errorRed`。
///
/// ## Features
/// - **List**: 展示所有人员，支持拖拽排序 (`ReorderableListView`).
/// - **Create**: 必须提供昵称，可选颜色。
/// - **Update**: 修改昵称和颜色。
/// - **Delete**: 删除前检查关联记录（Repository 层抛出异常时在 UI 层捕获并提示）。
/// - **Validation**: 默认用户 (Default Person) 不可删除（业务逻辑层控制，或视需求而定）。
///
/// ## Security
/// - 所有操作在本地加密数据库中执行。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/person.dart';
import '../../../logic/providers/core_providers.dart';
import '../../../logic/providers/person_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/l10n_helper.dart';

class PersonnelManagementPage extends ConsumerStatefulWidget {
  const PersonnelManagementPage({super.key});

  @override
  ConsumerState<PersonnelManagementPage> createState() =>
      _PersonnelManagementPageState();
}

class _PersonnelManagementPageState
    extends ConsumerState<PersonnelManagementPage> {
  // Pre-defined colors for profiles
  final List<String> _presetColors = [
    '#009688', // Teal 500 (Default)
    '#F44336', // Red 500
    '#E91E63', // Pink 500
    '#9C27B0', // Purple 500
    '#673AB7', // Deep Purple 500
    '#3F51B5', // Indigo 500
    '#2196F3', // Blue 500
    '#03A9F4', // Light Blue 500
    '#00BCD4', // Cyan 500
    '#00897B', // Teal 600
    '#4CAF50', // Green 500
    '#8BC34A', // Light Green 500
    '#CDDC39', // Lime 500
    '#FFEB3B', // Yellow 500
    '#FFC107', // Amber 500
    '#FF9800', // Orange 500
    '#FF5722', // Deep Orange 500
    '#795548', // Brown 500
    '#9E9E9E', // Grey 500
    '#607D8B', // Blue Grey 500
  ];

  @override
  Widget build(BuildContext context) {
    final personsAsync = ref.watch(allPersonsProvider);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,

      appBar: AppBar(
        title: Text(l10n.settings_manage_profiles),

        backgroundColor: AppTheme.bgWhite,

        foregroundColor: AppTheme.textPrimary,

        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(),

        backgroundColor: AppTheme.primaryTeal,

        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: personsAsync.when(
        data: (persons) => _buildList(context, persons),

        loading: () => const Center(child: CircularProgressIndicator()),

        error: (err, stack) => Center(
          child: Text(
            l10n.common_load_failed(err.toString()),

            style: const TextStyle(color: AppTheme.errorRed),
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Person> persons) {
    final l10n = AppLocalizations.of(context)!;

    if (persons.isEmpty) {
      return Center(
        child: Text(
          l10n.person_management_empty,
          style: const TextStyle(color: AppTheme.textHint),
        ),
      );
    }

    // Sort by orderIndex to ensure display matches logic
    // Note: Repository already sorts by order_index, but we ensure consistent UI state
    final sortedPersons = List<Person>.from(persons);
    // .sort((a, b) => a.orderIndex.compareTo(b.orderIndex)); // Already sorted by query

    return ReorderableListView.builder(
      itemCount: sortedPersons.length,
      padding: const EdgeInsets.only(bottom: 80),
      onReorder: (oldIndex, newIndex) =>
          _onReorder(sortedPersons, oldIndex, newIndex),
      itemBuilder: (context, index) {
        final person = sortedPersons[index];
        return _buildItem(context, person, index);
      },
    );
  }

  Widget _buildItem(BuildContext context, Person person, int index) {
    final l10n = AppLocalizations.of(context)!;
    final color = person.profileColor != null
        ? Color(int.parse(person.profileColor!.replaceAll('#', '0xFF')))
        : AppTheme.primaryTeal;

    return Container(
      key: ValueKey(person.id),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.bgGrey)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            L10nHelper.getPersonName(context, person).isNotEmpty
                ? L10nHelper.getPersonName(context, person)[0]
                : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          L10nHelper.getPersonName(context, person),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            fontFamily: AppTheme.fontPool,
          ),
        ),
        subtitle: person.isDefault
            ? Text(
                l10n.person_management_default,
                style: const TextStyle(fontSize: 12),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.textHint),
              onPressed: () => _showEditDialog(person: person),
            ),
            if (!person.isDefault)
              IconButton(
                icon: const Icon(Icons.delete, color: AppTheme.textHint),
                onPressed: () => _confirmDelete(person),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.drag_handle, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }

  Future<void> _onReorder(
    List<Person> currentList,
    int oldIndex,
    int newIndex,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, item);

    try {
      final personRepo = ref.read(personRepositoryProvider);
      await personRepo.updateOrder(currentList);
      ref.invalidate(allPersonsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.common_load_failed(e.toString())),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(Person person) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.person_delete_title),
        content: Text(
          l10n.person_delete_confirm(L10nHelper.getPersonName(context, person)),
        ),
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
    if (confirm == true) {
      try {
        final personRepo = ref.read(personRepositoryProvider);
        await personRepo.deletePerson(person.id);
        ref.invalidate(allPersonsProvider);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.common_confirm)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.common_load_failed(e.toString())),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    }
  }

  Future<void> _showEditDialog({Person? person}) async {
    await showDialog<void>(
      context: context,
      builder: (context) =>
          _PersonEditDialog(person: person, presetColors: _presetColors),
    );
  }
}

class _PersonEditDialog extends ConsumerStatefulWidget {
  final Person? person;
  final List<String> presetColors;

  const _PersonEditDialog({this.person, required this.presetColors});

  @override
  ConsumerState<_PersonEditDialog> createState() => _PersonEditDialogState();
}

class _PersonEditDialogState extends ConsumerState<_PersonEditDialog> {
  late TextEditingController _nameCtrl;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.person?.nickname ?? '');
    _selectedColor = widget.person?.profileColor ?? widget.presetColors[0];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.person != null;
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(isEditing ? l10n.person_edit_title : l10n.person_add_title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.person_field_nickname,
                hintText: l10n.person_field_nickname_hint,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.person_field_color,
              style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.presetColors.map((colorHex) {
                final isSelected = _selectedColor == colorHex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = colorHex),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(int.parse(colorHex.replaceAll('#', '0xFF'))),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.black54, width: 2)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        ElevatedButton(onPressed: _save, child: Text(l10n.common_save)),
      ],
    );
  }

  Future<void> _save() async {
    final nickname = _nameCtrl.text.trim();
    if (nickname.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      final personRepo = ref.read(personRepositoryProvider);
      if (widget.person != null) {
        await personRepo.updatePerson(
          widget.person!.copyWith(
            nickname: nickname,
            profileColor: _selectedColor,
          ),
        );
      } else {
        final allPersons = ref.read(allPersonsProvider).value ?? [];
        final newPerson = Person(
          id: const Uuid().v4(),
          nickname: nickname,
          profileColor: _selectedColor,
          createdAt: DateTime.now(),
          orderIndex: allPersons.length,
        );
        await personRepo.createPerson(newPerson);
      }
      ref.invalidate(allPersonsProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.common_load_failed(e.toString())),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }
}
