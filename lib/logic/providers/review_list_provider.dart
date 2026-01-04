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
      if (previous != null && next.hasValue && previous.hasValue) {
        if (next.value != previous.value) {
          refresh();
        }
      }
    });

    return _fetchRecords(personId);
  }

  Future<List<MedicalRecord>> _fetchRecords(String personId) async {
    final repo = ref.read(recordRepositoryProvider);
    return repo.getReviewRecords(personId);
  }

  Future<void> refresh() async {
    final personId = await ref.read(currentPersonIdControllerProvider.future);
    if (personId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRecords(personId));
  }

  /// 归档记录 (Approve)
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
}
