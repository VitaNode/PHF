// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TimelineController)
final timelineControllerProvider = TimelineControllerProvider._();

final class TimelineControllerProvider
    extends $AsyncNotifierProvider<TimelineController, HomeState> {
  TimelineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timelineControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timelineControllerHash();

  @$internal
  @override
  TimelineController create() => TimelineController();
}

String _$timelineControllerHash() =>
    r'4738ee77463b13887c5c18542b21e4b5effa6459';

abstract class _$TimelineController extends $AsyncNotifier<HomeState> {
  FutureOr<HomeState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeState>, HomeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeState>, HomeState>,
              AsyncValue<HomeState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
