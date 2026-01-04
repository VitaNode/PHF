import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/search_result.dart';
import 'core_providers.dart';
import 'person_provider.dart';

part 'search_provider.g.dart';

@riverpod
class SearchController extends _$SearchController {
  @override
  FutureOr<List<SearchResult>> build() {
    return [];
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    final personId = await ref.read(currentPersonIdControllerProvider.future);
    if (personId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(searchRepositoryProvider);
      return repo.search(query, personId);
    });
  }
}
