import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../core/logging/encrypted_log_service.dart';
import '../../core/logging/talker_file_observer.dart';

part 'logging_provider.g.dart';

@Riverpod(keepAlive: true)
EncryptedLogService encryptedLogService(Ref ref) {
  final service = EncryptedLogService();
  // Fire and forget pruning on startup
  service.pruneOldLogs();
  return service;
}

@Riverpod(keepAlive: true)
Talker talker(Ref ref) {
  final logService = ref.watch(encryptedLogServiceProvider);
  return Talker(
    settings: TalkerSettings(maxHistoryItems: 1000),
    observer: TalkerFileObserver(logService),
    logger: TalkerLogger(),
  );
}
