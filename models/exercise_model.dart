import 'package:hive/hive.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 1)
class ExerciseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String muscleGroup; // 'chest', 'back', 'legs', etc.

  @HiveField(3)
  final String equipment; // 'bodyweight', 'dumbbell', 'barbell', 'machine'

  @HiveField(4)
  final String imageUrl; // HTTPS URL

  @HiveField(5)
  final String videoUrl; // HTTPS MP4 URL

  @HiveField(6)
  final String instructions;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.imageUrl,
    required this.videoUrl,
    required this.instructions,
  });
}