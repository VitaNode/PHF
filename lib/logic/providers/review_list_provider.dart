import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/record.dart';
import 'core_providers.dart';
import 'ocr_status_provider.dart';

part 'review_list_provider.g.dart';

@riverpod
class ReviewListController extends _$ReviewListController {
  @override
  FutureOr<List<MedicalRecord>> build() async {
    // 监听 OCR 任务，当有任务完成时，刷新待确认列表
    ref.listen(ocrPendingCountProvider, (previous, next) {
      if (previous != null && next.hasValue && previous.hasValue) {
        if (next.value != previous.value) {
          refresh();
        }
      }
    });

    return _fetchRecords();
  }

  Future<List<MedicalRecord>> _fetchRecords() async {
    final repo = ref.read(recordRepositoryProvider);
    // TODO: Phase 2 Get Person ID from User Session
    const currentPersonId = 'def_me';
    return repo.getReviewRecords(currentPersonId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRecords());
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
