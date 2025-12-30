/// # Timeline Provider
///
/// ## Description
/// 管理首页时间轴（病历列表）的状态。
///
/// ## State
/// `List<MedicalRecord>`: 当前展示的病历列表。
///
/// ## Logic
/// - `loadRecords`: 加载全部（分页暂未实现，Phase 1 全量）。
/// - `search`: 根据关键字或 Tag 过滤。
/// - `delete`: 执行软删除并刷新列表。
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/record.dart';
import 'core_providers.dart';

part 'timeline_provider.g.dart';

@riverpod
class TimelineController extends _$TimelineController {
  @override
  FutureOr<List<MedicalRecord>> build() async {
    return _fetchRecords();
  }

  /// 内部获取当前用户的所有记录 (默认)
  Future<List<MedicalRecord>> _fetchRecords() async {
    final repo = ref.read(recordRepositoryProvider);
    final imageRepo = ref.read(imageRepositoryProvider);
    // TODO: Phase 2 Get Person ID from User Session
    const currentPersonId = 'def_me'; 
    final records = await repo.getRecordsByPerson(currentPersonId);

    // Enrich with images (Phase 1 N+1)
    final List<MedicalRecord> enriched = [];
    for (var rec in records) {
      final images = await imageRepo.getImagesForRecord(rec.id);
      enriched.add(rec.copyWith(images: images));
    }
    return enriched;
  }

  /// 刷新列表
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRecords());
  }

  /// 搜索与过滤
  Future<void> search({String? query, List<String>? tags}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(recordRepositoryProvider);
      final imageRepo = ref.read(imageRepositoryProvider);
      const currentPersonId = 'def_me';
      final records = await repo.searchRecords(
        personId: currentPersonId,
        query: query,
        tags: tags,
      );

      final List<MedicalRecord> enriched = [];
      for (var rec in records) {
        final images = await imageRepo.getImagesForRecord(rec.id);
        enriched.add(rec.copyWith(images: images));
      }
      return enriched;
    });
  }

  /// 删除记录
  Future<void> deleteRecord(String id) async {
    final repo = ref.read(recordRepositoryProvider);
    await repo.updateStatus(id, RecordStatus.deleted);
    // Refresh to reflect changes
    await refresh();
  }
}
