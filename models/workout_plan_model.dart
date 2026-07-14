import 'package:hive/hive.dart';

part 'workout_plan_model.g.dart';

@HiveType(typeId: 2)
class DailyWorkoutModel extends HiveObject {
  @HiveField(0)
  final String dayName; // 'Monday', 'Tuesday', etc.

  @HiveField(1)
  final String focus; // 'Push', 'Pull', 'Legs', 'Rest', 'Full Body'

  @HiveField(2)
  final List<ExerciseSetModel> exercises;

  @HiveField(3)
  final bool isRestDay;

  DailyWorkoutModel({
    required this.dayName,
    required this.focus,
    required this.exercises,
    required this.isRestDay,
  });
}

@HiveType(typeId: 3)
class ExerciseSetModel extends HiveObject {
  @HiveField(0)
  final String exerciseId; // Links to ExerciseModel

  @HiveField(1)
  final int sets;

  @HiveField(2)
  final int reps;

  @HiveField(3)
  final double? weightKg; // Null for bodyweight

  @HiveField(4)
  final int restSeconds;

  ExerciseSetModel({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    this.weightKg,
    required this.restSeconds,
  });
}

@HiveType(typeId: 4)
class WeeklyPlanModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime generatedAt;

  @HiveField(2)
  final List<DailyWorkoutModel> weekSchedule;

  WeeklyPlanModel({
    required this.id,
    required this.generatedAt,
    required this.weekSchedule,
  });
}