import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/workout_plan_model.dart';
import '../repositories/user_repository.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/workout_repository.dart';
import '../workout_engine/workout_plan_generator.dart';
import 'repository_providers.dart';

class UserState {
  final UserModel? user;
  final WeeklyPlanModel? currentPlan;
  final bool isLoading;

  UserState({this.user, this.currentPlan, this.isLoading = false});

  UserState copyWith({UserModel? user, WeeklyPlanModel? currentPlan, bool? isLoading}) {
    return UserState(
      user: user ?? this.user,
      currentPlan: currentPlan ?? this.currentPlan,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _userRepo;
  final ExerciseRepository _exRepo;
  final WorkoutRepository _workoutRepo;

  UserNotifier(this._userRepo, this._exRepo, this._workoutRepo) : super(UserState());

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true);
    final user = await _userRepo.getUser();
    WeeklyPlanModel? plan;
    if (user != null) {
      plan = await _workoutRepo.getLatestPlan();
    }
    state = state.copyWith(user: user, currentPlan: plan, isLoading: false);
  }

  Future<void> saveUserAndGeneratePlan(UserModel user) async {
    state = state.copyWith(isLoading: true);
    
    // 1. Save User
    await _userRepo.saveUser(user);
    
    // 2. Get Exercise Pool
    final exercises = await _exRepo.getAllExercises();
    
    // 3. Generate Plan
    final newPlan = WorkoutPlanGenerator.generatePlan(
      user: user,
      exercisePool: exercises,
    );
    
    // 4. Save Plan
    await _workoutRepo.saveWeeklyPlan(newPlan);
    
    state = state.copyWith(user: user, currentPlan: newPlan, isLoading: false);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(
    ref.watch(userRepositoryProvider),
    ref.watch(exerciseRepositoryProvider),
    ref.watch(workoutRepositoryProvider),
  );
});