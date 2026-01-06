import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/person.dart';
import '../../../data/models/search_result.dart';
import '../../../logic/providers/search_provider.dart';
import '../../../logic/providers/person_provider.dart';
import '../../theme/app_theme.dart';
import '../timeline/record_detail_page.dart';
import '../../widgets/app_card.dart';

/// # GlobalSearchPage
///
/// ## Description
/// 全屏搜索页面，支持基于 FTS5 的全文检索及结果高亮显示。
///
/// ## Features
/// - **FTS5 Search**: 检索医院、标签、备注及 OCR 文本。
/// - **Highlighting**: 自动解析并高亮显示匹配关键词。
/// - **Personnel Isolated**: 仅搜索当前选中成员的记录。
///
/// ## Repair Logs
/// - [2026-01-05] 修复：应用 Monospace 字体于搜索结果摘要，提升医疗数值可读性。
/// - [2026-01-05] 修复：优化 `_parseSnippet` 逻辑，确保高亮标签正确闭合及性能。
class GlobalSearchPage extends ConsumerStatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  ConsumerState<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends ConsumerState<GlobalSearchPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query == _lastQuery) return;
    _lastQuery = query;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      ref.read(searchControllerProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchControllerProvider);
    final currentPerson = ref.watch(currentPersonProvider).value;

    return Scaffold(
      backgroundColor: AppTheme.bgGrey,
      appBar: _buildAppBar(currentPerson),
      body: searchAsync.when(
        data: (results) => _buildSearchResults(results),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryTeal),
        ),
        error: (err, stack) => Center(
          child: Text(
            '搜索出错: $err',
            style: const TextStyle(color: AppTheme.errorRed),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Person? currentPerson) {
    return AppBar(
      titleSpacing: 0,
      title: _buildSearchField(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: Container(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 14,
                color: AppTheme.textHint,
              ),
              const SizedBox(width: 4),
              Text(
                '正在搜索: ${currentPerson?.nickname ?? "加载中..."}',
                style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppTheme.bgGrey,
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: '搜索 OCR 内容、医院或备注...',
          hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 14),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppTheme.textGrey,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    size: 20,
                    color: AppTheme.textGrey,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                    _onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        style: const TextStyle(fontSize: 16),
        onChanged: (val) {
          setState(() {});
          _onSearchChanged(val);
        },
        textInputAction: TextInputAction.search,
        onSubmitted: (val) =>
            ref.read(searchControllerProvider.notifier).search(val),
      ),
    );
  }

  Widget _buildSearchResults(List<SearchResult> results) {
    if (results.isEmpty && _searchController.text.isNotEmpty) {
      return _buildEmptyState();
    }
    if (results.isEmpty) {
      return _buildInitialState();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '找到 ${results.length} 条结果',
            style: AppTheme.monoStyle.copyWith(
              fontSize: 12,
              color: AppTheme.textHint,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: results.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SearchResultCard(result: results[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 80,
            color: AppTheme.primaryTeal.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          const Text(
            '支持搜索病历内容、医院或标签',
            style: TextStyle(color: AppTheme.textHint, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            '试试搜索 "血常规" 或 "省立医院"',
            style: TextStyle(color: AppTheme.textHint, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sentiment_dissatisfied,
            size: 64,
            color: AppTheme.textHint,
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
              children: [
                const TextSpan(text: '未找到相关内容 '),
                TextSpan(
                  text: '"${_searchController.text}"',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryTeal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '请尝试更换关键词或检查拼写',
            style: TextStyle(color: AppTheme.textHint, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final SearchResult result;

  const _SearchResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => RecordDetailPage(recordId: result.record.id),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(height: 1, color: AppTheme.bgGrey),
          if (result.snippet.isNotEmpty) _buildSnippet(),
          _buildTags(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(
            Icons.local_hospital,
            size: 16,
            color: AppTheme.primaryTeal,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              result.record.hospitalName ?? '未填写医院',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('yyyy-MM-dd').format(result.record.notedAt),
            style: AppTheme.monoStyle.copyWith(
              fontSize: 12,
              color: AppTheme.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnippet() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.notes, size: 14, color: AppTheme.textHint),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: _parseSnippet(result.snippet),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    if (result.record.tagsCache == null || result.record.tagsCache!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Wrap(
        spacing: 4,
        children: result.record.tagsCache!.split(',').take(3).map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.bgGrey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '#$tag',
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  TextSpan _parseSnippet(String snippet) {
    final List<TextSpan> spans = [];
    final RegExp exp = RegExp(r'(.*?)<b>(.*?)</b>', dotAll: true);

    int lastIndex = 0;
    for (final match in exp.allMatches(snippet)) {
      // Normal text
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: snippet
                .substring(lastIndex, match.start)
                .replaceAll('\n', ' '),
            style: AppTheme.monoStyle.copyWith(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        );
      }
      // Highlighted text
      spans.add(
        TextSpan(
          text: match.group(2),
          style: AppTheme.monoStyle.copyWith(
            color: AppTheme.primaryTeal,
            fontWeight: FontWeight.bold,
            backgroundColor: const Color(0x20008080), // 12% opacity teal
            fontSize: 13,
          ),
        ),
      );
      lastIndex = match.end;
    }

    // Remaining text
    if (lastIndex < snippet.length) {
      spans.add(
        TextSpan(
          text: snippet.substring(lastIndex).replaceAll('\n', ' '),
          style: AppTheme.monoStyle.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 13,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
