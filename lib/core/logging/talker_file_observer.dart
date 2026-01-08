import 'package:talker_flutter/talker_flutter.dart';
import 'encrypted_log_service.dart';

class TalkerFileObserver extends TalkerObserver {
  final EncryptedLogService _service;

  TalkerFileObserver(this._service);

  @override
  void onLog(TalkerData log) {
    _service.log(log.generateTextMessage());
  }

  @override
  void onError(TalkerError err) {
    _service.log(err.generateTextMessage());
  }

  @override
  void onException(TalkerException err) {
    _service.log(err.generateTextMessage());
  }
}
