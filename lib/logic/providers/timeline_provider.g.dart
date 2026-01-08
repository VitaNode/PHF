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
    r'65c01d01398746476361a12098549ba42f4079a9';

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
