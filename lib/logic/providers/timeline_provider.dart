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
///
/// ## 修复记录
/// - [issue#22] 重构 `TimelineController` 以支持持久化和多维过滤（日期、标签）。
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/record.dart';
import 'core_providers.dart';
import 'logging_provider.dart';
import 'person_provider.dart';
import 'states/home_state.dart';
import 'ocr_status_provider.dart';

part 'timeline_provider.g.dart';

@riverpod
class TimelineController extends _$TimelineController {
  @override
  FutureOr<HomeState> build() async {
    final talker = ref.watch(talkerProvider);
    // 监听当前人员变更，触发重新加载
    final personId = await ref.watch(currentPersonIdControllerProvider.future);

    if (personId == null) {
      return const HomeState(records: [], pendingCount: 0);
    }

    // 监听 OCR 任务状态
    ref.listen(ocrPendingCountProvider, (previous, next) {
      if (next.hasValue) {
        final nextCount = next.value!;
        final prevCount = previous?.value ?? -1;

        // 仅当数量减少（任务完成）或状态从无变有（开始任务）时触发刷新
        // 且为了避免 Assertion Error，确保不在 build 过程中直接修改状态
        if (nextCount != prevCount) {
          talker.info(
            '[TimelineController] OCR Status update: $prevCount -> $nextCount. Triggering deferred refresh.',
          );

          // 使用 Future.microtask 确保在当前 build cycle 之后执行，避免 assertion error
          Future.microtask(() {
            // 只有当当前没有在加载时才刷新，或者直接调用 refresh()
            // refresh() 内部会处理 AsyncValue.loading()
            refresh();
          });
        }
      }
    });

    return _fetchRecords(personId);
  }

  /// 内部获取当前用户的所有记录
  Future<HomeState> _fetchRecords(
    String personId, {
    String? query,
    List<String>? tags,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final repo = ref.read(recordRepositoryProvider);
    final imageRepo = ref.read(imageRepositoryProvider);

    final records = await repo.searchRecords(
      personId: personId,
      query: query,
      tags: tags,
      startDate: startDate,
      endDate: endDate,
    );
    final pendingCount = await repo.getPendingCount(personId);

    // Enrich with images (Phase 1 N+1)
    final List<MedicalRecord> enriched = [];
    for (var rec in records) {
      final images = await imageRepo.getImagesForRecord(rec.id);
      enriched.add(rec.copyWith(images: images));
    }

    return HomeState(
      records: enriched,
      pendingCount: pendingCount,
      filterTags: tags,
      startDate: startDate,
      endDate: endDate,
      searchQuery: query,
    );
  }

  /// 刷新列表

  Future<void> refresh() async {
    // 防止并发刷新导致的状态竞争
    if (state.isLoading && state.value != null) return;

    final personId = await ref.read(currentPersonIdControllerProvider.future);
    if (personId == null) return;

    final currentQuery = state.value?.searchQuery;
    final currentTags = state.value?.filterTags;
    final currentStart = state.value?.startDate;
    final currentEnd = state.value?.endDate;

    // 保持旧数据展示的同时进入加载状态 (Data-first loading)
    // state = const AsyncValue.loading(); // 这样会导致 UI 闪烁/清空，不推荐在此处用

    final newState = await AsyncValue.guard(
      () => _fetchRecords(
        personId,
        query: currentQuery,
        tags: currentTags,
        startDate: currentStart,
        endDate: currentEnd,
      ),
    );

    if (newState.hasValue) {
      state = newState;
    }
  }

  /// 搜索与过滤
  Future<void> search({
    String? query,
    List<String>? tags,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final personId = await ref.read(currentPersonIdControllerProvider.future);
    if (personId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _fetchRecords(
        personId,
        query: query,
        tags: tags,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  /// 删除记录
  Future<void> deleteRecord(String id) async {
    final repo = ref.read(recordRepositoryProvider);
    await repo.updateStatus(id, RecordStatus.deleted);
    // Refresh to reflect changes
    await refresh();
  }
}
