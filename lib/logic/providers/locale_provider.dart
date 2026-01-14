import 'package:flutter/material.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleController extends _$LocaleController {
  static const _localeKey = 'app_locale';

  @override
  FutureOr<Locale?> build() async {
    final repo = ref.watch(appMetaRepositoryProvider);
    final localeCode = await repo.get(_localeKey);
    if (localeCode != null && localeCode.isNotEmpty) {
      return Locale(localeCode);
    }
    return null; // Null means follow system
  }

  Future<void> setLocale(String? languageCode) async {
    final repo = ref.read(appMetaRepositoryProvider);
    if (languageCode == null) {
      await repo.put(_localeKey, '');
      state = const AsyncValue.data(null);
    } else {
      await repo.put(_localeKey, languageCode);
      state = AsyncValue.data(Locale(languageCode));
    }
  }
}
