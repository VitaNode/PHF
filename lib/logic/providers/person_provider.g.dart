// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 所有人员列表 Provider

@ProviderFor(allPersons)
final allPersonsProvider = AllPersonsProvider._();

/// 所有人员列表 Provider

final class AllPersonsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Person>>,
          List<Person>,
          FutureOr<List<Person>>
        >
    with $FutureModifier<List<Person>>, $FutureProvider<List<Person>> {
  /// 所有人员列表 Provider
  AllPersonsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allPersonsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPersonsHash();

  @$internal
  @override
  $FutureProviderElement<List<Person>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Person>> create(Ref ref) {
    return allPersons(ref);
  }
}

String _$allPersonsHash() => r'e47bf00f2d2518b2d9c5592c711b150bef352b1c';

/// 当前选中的人员 ID Provider (持久化)

@ProviderFor(CurrentPersonIdController)
final currentPersonIdControllerProvider = CurrentPersonIdControllerProvider._();

/// 当前选中的人员 ID Provider (持久化)
final class CurrentPersonIdControllerProvider
    extends $AsyncNotifierProvider<CurrentPersonIdController, String?> {
  /// 当前选中的人员 ID Provider (持久化)
  CurrentPersonIdControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPersonIdControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPersonIdControllerHash();

  @$internal
  @override
  CurrentPersonIdController create() => CurrentPersonIdController();
}

String _$currentPersonIdControllerHash() =>
    r'64f3bc61edf55946d49087070ad5f9f412c84b69';

/// 当前选中的人员 ID Provider (持久化)

abstract class _$CurrentPersonIdController extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// 当前人员实体 Provider
///
/// 业务层通常监听此 Provider 以获取当前人员的所有信息。

@ProviderFor(currentPerson)
final currentPersonProvider = CurrentPersonProvider._();

/// 当前人员实体 Provider
///
/// 业务层通常监听此 Provider 以获取当前人员的所有信息。

final class CurrentPersonProvider
    extends $FunctionalProvider<AsyncValue<Person?>, Person?, FutureOr<Person?>>
    with $FutureModifier<Person?>, $FutureProvider<Person?> {
  /// 当前人员实体 Provider
  ///
  /// 业务层通常监听此 Provider 以获取当前人员的所有信息。
  CurrentPersonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPersonProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPersonHash();

  @$internal
  @override
  $FutureProviderElement<Person?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Person?> create(Ref ref) {
    return currentPerson(ref);
  }
}

String _$currentPersonHash() => r'e06216edbad452b12e831f6b33d85ab1de6ee6bc';
