import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final String gender; // 'male', 'female', 'other'

  @HiveField(4)
  final double heightCm;

  @HiveField(5)
  final double weightKg;

  @HiveField(6)
  final String goal; // 'lose_weight', 'maintain', 'build_muscle'

  @HiveField(7)
  final String experienceLevel; // 'beginner', 'intermediate', 'advanced'

  @HiveField(8)
  final int trainingDaysPerWeek; // 1 to 7

  @HiveField(9)
  final String workoutLocation; // 'home', 'gym', 'both'

  @HiveField(10)
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.goal,
    required this.experienceLevel,
    required this.trainingDaysPerWeek,
    required this.workoutLocation,
    required this.createdAt,
  });
}