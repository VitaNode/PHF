import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/record.dart';
import 'core_providers.dart';
import 'ocr_status_provider.dart';
import 'person_provider.dart';

part 'review_list_provider.g.dart';

@riverpod
class ReviewListController extends _$ReviewListController {
  @override
  FutureOr<List<MedicalRecord>> build() async {
    // 监听当前人员变更
    final personId = await ref.watch(currentPersonIdControllerProvider.future);

    if (personId == null) return [];

    // 监听 OCR 任务，当有任务完成时，刷新待确认列表
    ref.listen(ocrPendingCountProvider, (previous, next) {
      if (next.hasValue) {
        final nextCount = next.value!;
        final prevCount = previous?.value ?? -1;

        if (nextCount != prevCount) {
          Future.microtask(() => refresh());
        }
      }
    });

    return _fetchRecords(personId);
  }

  Future<void> approveRecord(String id) async {
    final repo = ref.read(recordRepositoryProvider);
    await repo.updateStatus(id, RecordStatus.archived);
    // Refresh list
    ref.invalidateSelf();
  }

  /// 删除记录 (Delete)
  Future<void> deleteRecord(String id) async {
    final repo = ref.read(recordRepositoryProvider);
    await repo.updateStatus(id, RecordStatus.deleted);
    // Refresh list
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    if (state.isLoading && state.value != null) return;

    final personId = await ref.read(currentPersonIdControllerProvider.future);
    if (personId == null) return;

    final newState = await AsyncValue.guard(() => _fetchRecords(personId));
    if (newState.hasValue) {
      state = newState;
    }
  }

  Future<List<MedicalRecord>> _fetchRecords(String personId) async {
    final repo = ref.read(recordRepositoryProvider);
    return repo.getReviewRecords(personId);
  }
}
