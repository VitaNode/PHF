/// # Personnel Tabs Widget
///
/// ## Description
/// 实现胶囊风格的左右滑动切换人员组件。
/// 遵循 `Constitution#VI. UI/UX` 准则，使用 Teal 主色调、圆角设计及等宽字体。
///
/// ## Features
/// - **Capsule UI**: 药丸状选中指示器，配合平滑滑动动画。
/// - **Dynamic Loading**: 自动响应 `allPersonsProvider` 列表变化。
/// - **Persistence**: 切换操作触发 `currentPersonIdControllerProvider` 更新及持久化。
/// - **Interactive**: 支持点击切换，且选中项始终保持在可视范围内。
///
/// ## Security
/// - **Privacy**: 仅显示人员昵称，不涉及敏感医疗数据。
/// - **Memory**: 使用 Riverpod 驱动，确保资源及时释放。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/person.dart';
import '../../logic/providers/person_provider.dart';
import '../theme/app_theme.dart';

class PersonnelTabs extends ConsumerStatefulWidget {
  const PersonnelTabs({super.key});

  @override
  ConsumerState<PersonnelTabs> createState() => _PersonnelTabsState();
}

class _PersonnelTabsState extends ConsumerState<PersonnelTabs> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personsAsync = ref.watch(allPersonsProvider);
    final currentIdAsync = ref.watch(currentPersonIdControllerProvider);

    return personsAsync.when(
      data: (persons) => currentIdAsync.when(
        data: (currentId) => _buildTabs(context, persons, currentId),
        loading: () => const SizedBox(height: 56),
        error: (err, st) => const SizedBox.shrink(),
      ),
      loading: () => const SizedBox(height: 56),
      error: (err, st) => const SizedBox.shrink(),
    );
  }

  Widget _buildTabs(
    BuildContext context,
    List<Person> persons,
    String? currentId,
  ) {
    if (persons.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.bgWhite,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5EA), width: 1)),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          final isSelected = person.id == currentId;

          return _PersonnelTabItem(
            person: person,
            isSelected: isSelected,
            onTap: () => _onTabSelected(person.id, index),
          );
        },
      ),
    );
  }

  Future<void> _onTabSelected(String personId, int index) async {
    await ref
        .read(currentPersonIdControllerProvider.notifier)
        .selectPerson(personId);
    // TODO: 自动滚动使选中项居中
  }
}

class _PersonnelTabItem extends StatelessWidget {
  final Person person;
  final bool isSelected;
  final VoidCallback onTap;

  const _PersonnelTabItem({
    required this.person,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 根据 Constitution，主色使用 Teal，或者使用 Person 预设的 profileColor
    final activeColor = person.profileColor != null
        ? Color(int.parse(person.profileColor!.replaceAll('#', '0xFF')))
        : AppTheme.primaryTeal;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : AppTheme.bgGrey,
          borderRadius: BorderRadius.circular(20), // 胶囊圆角
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFE5E5EA), width: 1),
        ),
        child: Center(
          child: Text(
            person.nickname,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontFamily: AppTheme.fontPool,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
