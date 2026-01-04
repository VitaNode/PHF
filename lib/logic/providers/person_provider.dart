/// # Person Providers
///
/// ## Description
/// 管理多人员切换的核心状态。
/// 负责加载人员列表、持久化当前选择的人员，并提供隔离后的数据过滤基准。
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/person.dart';
import 'core_providers.dart';

part 'person_provider.g.dart';

/// 所有人员列表 Provider
@Riverpod(keepAlive: true)
Future<List<Person>> allPersons(Ref ref) async {
  final repo = ref.watch(personRepositoryProvider);
  return repo.getAllPersons();
}

/// 当前选中的人员 ID Provider (持久化)
@Riverpod(keepAlive: true)
class CurrentPersonIdController extends _$CurrentPersonIdController {
  @override
  Future<String?> build() async {
    final metaRepo = ref.watch(appMetaRepositoryProvider);
    final savedId = await metaRepo.getCurrentPersonId();

    if (savedId != null) return savedId;

    // 如果没有存过的 ID，尝试寻找默认用户 (Me)
    final persons = await ref.watch(allPersonsProvider.future);
    if (persons.isNotEmpty) {
      try {
        final defaultPerson = persons.firstWhere((p) => p.isDefault);
        return defaultPerson.id;
      } catch (_) {
        return persons.first.id;
      }
    }

    return null;
  }

  /// 切换当前选中的人员
  Future<void> selectPerson(String id) async {
    final metaRepo = ref.read(appMetaRepositoryProvider);
    await metaRepo.setCurrentPersonId(id);
    state = AsyncData(id);
  }
}

/// 当前人员实体 Provider
///
/// 业务层通常监听此 Provider 以获取当前人员的所有信息。
@Riverpod(keepAlive: true)
Future<Person?> currentPerson(Ref ref) async {
  final id = await ref.watch(currentPersonIdControllerProvider.future);
  if (id == null) return null;

  final persons = await ref.watch(allPersonsProvider.future);
  try {
    return persons.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}
