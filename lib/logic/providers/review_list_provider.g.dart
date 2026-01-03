// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReviewListController)
final reviewListControllerProvider = ReviewListControllerProvider._();

final class ReviewListControllerProvider
    extends $AsyncNotifierProvider<ReviewListController, List<MedicalRecord>> {
  ReviewListControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'reviewListControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$reviewListControllerHash();

  @$internal
  @override
  ReviewListController create() => ReviewListController();
}

String _$reviewListControllerHash() =>
    r'5410fadf0a4590de2ab5c9b464f68b2d49443629';

abstract class _$ReviewListController
    extends $AsyncNotifier<List<MedicalRecord>> {
  FutureOr<List<MedicalRecord>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<MedicalRecord>>, List<MedicalRecord>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<MedicalRecord>>, List<MedicalRecord>>,
        AsyncValue<List<MedicalRecord>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
