// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SecuritySettingsController)
final securitySettingsControllerProvider =
    SecuritySettingsControllerProvider._();

final class SecuritySettingsControllerProvider
    extends
        $AsyncNotifierProvider<
          SecuritySettingsController,
          SecuritySettingsState
        > {
  SecuritySettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'securitySettingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$securitySettingsControllerHash();

  @$internal
  @override
  SecuritySettingsController create() => SecuritySettingsController();
}

String _$securitySettingsControllerHash() =>
    r'49261e28d3b20ff68324da9ed7f97385a19286ed';

abstract class _$SecuritySettingsController
    extends $AsyncNotifier<SecuritySettingsState> {
  FutureOr<SecuritySettingsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<SecuritySettingsState>, SecuritySettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SecuritySettingsState>,
                SecuritySettingsState
              >,
              AsyncValue<SecuritySettingsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
