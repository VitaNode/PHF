/// # Person Providers
///
/// ## Description
/// 管理多人员切换的核心状态。
/// 负责加载人员列表、持久化当前选择的人员，并提供隔离后的数据过滤基准。
///
/// ## 修复记录
/// - [issue#14] 优化 `currentPerson` provider，使用 `firstOrNull` 替代 `try-catch`；为 `selectPerson` 增加错误捕捉与日志记录。
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/person.dart';
import 'core_providers.dart';
import 'logging_provider.dart';

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
    try {
      final metaRepo = ref.read(appMetaRepositoryProvider);
      await metaRepo.setCurrentPersonId(id);
      state = AsyncData(id);
    } catch (e, stack) {
      ref
          .read(talkerProvider)
          .handle(
            e,
            stack,
            '[CurrentPersonIdController] Failed to select person',
          );
      rethrow;
    }
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
  return persons.where((p) => p.id == id).firstOrNull;
}
