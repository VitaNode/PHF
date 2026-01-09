// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingestion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IngestionController)
final ingestionControllerProvider = IngestionControllerProvider._();

final class IngestionControllerProvider
    extends $NotifierProvider<IngestionController, IngestionState> {
  IngestionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingestionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingestionControllerHash();

  @$internal
  @override
  IngestionController create() => IngestionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngestionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngestionState>(value),
    );
  }
}

String _$ingestionControllerHash() =>
    r'67eed9a8e6c05685b61d132ac9f6e258d1c72f73';

abstract class _$IngestionController extends $Notifier<IngestionState> {
  IngestionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<IngestionState, IngestionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IngestionState, IngestionState>,
              IngestionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
