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
import 'logging_provider.dart';
import 'states/home_state.dart';
import 'ocr_status_provider.dart';

part 'timeline_provider.g.dart';

@riverpod
class TimelineController extends _$TimelineController {
  @override
  FutureOr<HomeState> build() async {
    final talker = ref.watch(talkerProvider);

    // 监听 OCR 任务状态
    ref.listen(ocrPendingCountProvider, (previous, next) {
      // 只要 next 有值且与 previous 不同
      if (next.hasValue) {
        final nextCount = next.value!;
        final prevCount = previous?.value ?? -1;

        if (nextCount != prevCount) {
          talker.info('[TimelineController] OCR Status update: $prevCount -> $nextCount. Triggering refresh.');
          refresh();
        }
      }
    });

    return _fetchRecords();
  }

  /// 内部获取当前用户的所有记录 (默认)
  Future<HomeState> _fetchRecords() async {
    final repo = ref.read(recordRepositoryProvider);
    final imageRepo = ref.read(imageRepositoryProvider);
    // TODO: Phase 2 Get Person ID from User Session
    const currentPersonId = 'def_me'; 
    final records = await repo.getRecordsByPerson(currentPersonId);
    final pendingCount = await repo.getPendingCount(currentPersonId);

    // Enrich with images (Phase 1 N+1)
    final List<MedicalRecord> enriched = [];
    for (var rec in records) {
      final images = await imageRepo.getImagesForRecord(rec.id);
      enriched.add(rec.copyWith(images: images));
    }
    
    return HomeState(
      records: enriched,
      pendingCount: pendingCount,
    );
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
      final pendingCount = await repo.getPendingCount(currentPersonId);

      final List<MedicalRecord> enriched = [];
      for (var rec in records) {
        final images = await imageRepo.getImagesForRecord(rec.id);
        enriched.add(rec.copyWith(images: images));
      }
      
      return HomeState(
        records: enriched,
        pendingCount: pendingCount,
      );
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
