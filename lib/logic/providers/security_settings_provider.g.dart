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
    r'ac0e9b604fcb7ab1cc5e16d729e0642e1c7e5214';

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
