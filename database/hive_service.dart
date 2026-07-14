import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/exercise_model.dart';
import '../models/workout_plan_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ExerciseModelAdapter());
    Hive.registerAdapter(DailyWorkoutModelAdapter());
    Hive.registerAdapter(ExerciseSetModelAdapter());
    Hive.registerAdapter(WeeklyPlanModelAdapter());
  }

  static Future<Box<UserModel>> getUserBox() async {
    return await Hive.openBox<UserModel>('users');
  }

  static Future<Box<ExerciseModel>> getExerciseBox() async {
    return await Hive.openBox<ExerciseModel>('exercises');
  }

  static Future<Box<WeeklyPlanModel>> getPlanBox() async {
    return await Hive.openBox<WeeklyPlanModel>('weekly_plans');
  }
}