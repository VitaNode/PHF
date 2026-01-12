import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import '../../../data/models/person.dart';
import '../../../data/models/search_result.dart';
import '../../../data/models/tag.dart';
import '../../../logic/providers/core_providers.dart';
import '../../../logic/providers/search_provider.dart';
import '../../../logic/providers/person_provider.dart';
import '../../theme/app_theme.dart';
import '../timeline/record_detail_page.dart';
import '../../widgets/app_card.dart';
import '../../utils/l10n_helper.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
            l10n.common_load_failed(err.toString()),
            style: const TextStyle(color: AppTheme.errorRed),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Person? currentPerson) {
    final l10n = AppLocalizations.of(context)!;

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
                l10n.search_searching_person(
                  currentPerson != null
                      ? L10nHelper.getPersonName(context, currentPerson)
                      : "...",
                ),
                style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final l10n = AppLocalizations.of(context)!;

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
          hintText: l10n.search_hint,
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
    final l10n = AppLocalizations.of(context)!;

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
            l10n.search_result_count(results.length),
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
    final l10n = AppLocalizations.of(context)!;
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
          Text(
            l10n.search_initial_title,
            style: const TextStyle(color: AppTheme.textHint, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.search_initial_desc,
            style: const TextStyle(color: AppTheme.textHint, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
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
                TextSpan(text: '${l10n.search_empty_title} '),
                TextSpan(
                  text: '"${_searchController.text}" ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryTeal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.search_empty_desc,
            style: const TextStyle(color: AppTheme.textHint, fontSize: 14),
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
          _buildHeader(context),
          const Divider(height: 1, color: AppTheme.bgGrey),
          if (result.snippet.isNotEmpty) _buildSnippet(),
          _buildTags(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              result.record.hospitalName ?? l10n.review_edit_hospital_label,
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

  Widget _buildTags(BuildContext context) {
    if (result.record.tagsCache == null || result.record.tagsCache!.isEmpty) {
      return const SizedBox.shrink();
    }
    List<String> tagIds = [];
    try {
      final decoded = jsonDecode(result.record.tagsCache!);
      if (decoded is List) {
        tagIds = decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {
      // Fallback for legacy comma-separated string if any
      tagIds = result.record.tagsCache!.split(',');
    }

    if (tagIds.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Wrap(
        spacing: 4,
        children: tagIds.take(3).map((tid) {
          return _SearchTagChip(tagId: tid);
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

class _SearchTagChip extends ConsumerWidget {
  final String tagId;
  const _SearchTagChip({required this.tagId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTagsAsync = ref.watch(allTagsProvider);
    return allTagsAsync.when(
      data: (allTags) {
        final tag = allTags.firstWhere(
          (t) => t.id == tagId,
          orElse: () =>
              Tag(id: tagId, name: tagId, createdAt: DateTime(0), color: ''),
        );
        final displayName = L10nHelper.getTagName(context, tag);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.bgGrey,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '#$displayName',
            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
