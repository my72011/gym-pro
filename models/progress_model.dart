import 'package:hive/hive.dart';

part 'progress_model.g.dart';

@HiveType(typeId: 5)
class ProgressLog extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double? weightKg; // Null if only logging workout completion

  @HiveField(2)
  final bool workoutCompleted;

  ProgressLog({
    required this.date,
    this.weightKg,
    required this.workoutCompleted,
  });
}