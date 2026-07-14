import 'package:hive/hive.dart';
import '../models/progress_model.dart';

abstract class ProgressRepository {
  Future<void> logProgress(ProgressLog log);
  Future<List<ProgressLog>> getAllLogs();
}

class ProgressRepositoryImpl implements ProgressRepository {
  final Box<ProgressLog> _progressBox;

  ProgressRepositoryImpl(this._progressBox);

  @override
  Future<void> logProgress(ProgressLog log) async {
    // Use timestamp as key to allow multiple logs per day if needed, or overwrite
    final key = log.date.millisecondsSinceEpoch.toString();
    await _progressBox.put(key, log);
  }

  @override
  Future<List<ProgressLog>> getAllLogs() async {
    final logs = _progressBox.values.toList();
    logs.sort((a, b) => a.date.compareTo(b.date));
    return logs;
  }
}