import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/search_result.dart';
import '../../../logic/providers/search_provider.dart';
import '../../theme/app_theme.dart';
import '../timeline/record_detail_page.dart';

class GlobalSearchPage extends ConsumerStatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  ConsumerState<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends ConsumerState<GlobalSearchPage> {
  final _searchController = TextEditingController();
  // Simple debounce
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query == _lastQuery) return;
    _lastQuery = query;
    // Debounce is good, but for now simple trigger
    // Using a delay or Stream would be better, but let's just trigger after 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (query != _lastQuery) return; // Query changed during delay
      ref.read(searchControllerProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '搜索 OCR 内容、医院或备注...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintStyle: TextStyle(color: AppTheme.textHint),
          ),
          style: const TextStyle(fontSize: 18),
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          onSubmitted: (val) => ref.read(searchControllerProvider.notifier).search(val),
        ),
        backgroundColor: AppTheme.bgWhite,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
        ],
      ),
      body: searchAsync.when(
        data: (results) {
          if (results.isEmpty && _searchController.text.isNotEmpty) {
            return _buildEmptyState();
          }
          if (results.isEmpty) {
            return const Center(child: Text('输入关键词开始搜索', style: TextStyle(color: AppTheme.textHint)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _SearchResultCard(result: results[index]);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryTeal),
        ),
        error: (err, stack) => Center(child: Text('搜索出错: $err')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppTheme.textHint),
          const SizedBox(height: 16),
          Text(
            '未找到相关内容 "${_searchController.text}"',
            style: const TextStyle(color: AppTheme.textHint, fontSize: 16),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => RecordDetailPage(recordId: result.record.id)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.bgGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Hospital + Date)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital, size: 16, color: AppTheme.primaryTeal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      result.record.hospitalName ?? '未填写',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd').format(result.record.notedAt),
                    style: AppTheme.monoStyle.copyWith(fontSize: 12, color: AppTheme.textHint),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Snippet Content
            if (result.snippet.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.text_snippet_outlined, size: 16, color: AppTheme.textHint),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: _parseSnippet(result.snippet),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  TextSpan _parseSnippet(String snippet) {
    // FTS5 snippet format: ... foo <b>bar</b> baz ...
    // We need to parse <b> and </b> tags.
    // Simple regex parser.
    final List<TextSpan> spans = [];
    final RegExp exp = RegExp(r'(.*?)<b>(.*?)</b>');
    
    // This simple loop might miss trailing text or complex nesting (FTS5 doesn't nest).
    // Better strategy: split by <b> then </b>.
    // Or use splitMapJoin logic manually.
    
    // Let's iterate using split.
    // "prefix <b>match</b> suffix <b>match2</b> tail"
    
    int lastIndex = 0;
    // Find all matches
    for (final match in exp.allMatches(snippet)) {
      // Add text before <b>
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: snippet.substring(lastIndex, match.start),
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ));
      }
      // Add text inside <b>
      spans.add(TextSpan(
        text: match.group(2), // The content inside <b>...</b>
        style: const TextStyle(
          color: AppTheme.primaryTeal, 
          fontWeight: FontWeight.bold, 
          backgroundColor: Color(0xFFE0F2F1), // Light teal bg
          fontSize: 13,
        ),
      ));
      lastIndex = match.end;
    }
    
    // Add remaining text
    if (lastIndex < snippet.length) {
      spans.add(TextSpan(
        text: snippet.substring(lastIndex),
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
      ));
    }

    return TextSpan(children: spans);
  }
}
