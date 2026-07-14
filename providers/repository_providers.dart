import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../models/exercise_model.dart';
import '../models/workout_plan_model.dart';
import '../models/progress_model.dart';
import '../repositories/user_repository.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/workout_repository.dart';
import '../repositories/progress_repository.dart';

// Box Providers
final userBoxProvider = Provider<Box<UserModel>>((ref) => throw UnimplementedError());
final exerciseBoxProvider = Provider<Box<ExerciseModel>>((ref) => throw UnimplementedError());
final settingsBoxProvider = Provider<Box<bool>>((ref) => throw UnimplementedError());
final planBoxProvider = Provider<Box<WeeklyPlanModel>>((ref) => throw UnimplementedError());
final progressBoxProvider = Provider<Box<ProgressLog>>((ref) => throw UnimplementedError());

// Repository Providers
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepositoryImpl(ref.watch(userBoxProvider)));
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) => ExerciseRepositoryImpl(ref.watch(exerciseBoxProvider), ref.watch(settingsBoxProvider)));
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) => WorkoutRepositoryImpl(ref.watch(planBoxProvider)));
final progressRepositoryProvider = Provider<ProgressRepository>((ref) => ProgressRepositoryImpl(ref.watch(progressBoxProvider)));

// Data Providers
final allExercisesProvider = FutureProvider<List<ExerciseModel>>((ref) async => await ref.watch(exerciseRepositoryProvider).getAllExercises());