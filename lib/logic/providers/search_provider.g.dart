// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchController)
final searchControllerProvider = SearchControllerProvider._();

final class SearchControllerProvider
    extends $AsyncNotifierProvider<SearchController, List<SearchResult>> {
  SearchControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchControllerHash();

  @$internal
  @override
  SearchController create() => SearchController();
}

String _$searchControllerHash() => r'e897c26463d6a80caff44d0fee2c2e3625a27417';

abstract class _$SearchController extends $AsyncNotifier<List<SearchResult>> {
  FutureOr<List<SearchResult>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<SearchResult>>, List<SearchResult>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<SearchResult>>, List<SearchResult>>,
        AsyncValue<List<SearchResult>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
