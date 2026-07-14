import '../core/constants/enums.dart';
import '../models/exercise_model.dart';
import '../models/workout_plan_model.dart';
import '../models/user_model.dart';
import '../exercise_engine/exercise_selector.dart';

class WorkoutPlanGenerator {
  static final List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  static WorkoutSplit determineSplit(UserModel user) {
    final days = user.trainingDaysPerWeek;
    if (days <= 2) return WorkoutSplit.full_body;
    if (days == 3) return user.experienceLevel == ExperienceLevel.beginner.name ? WorkoutSplit.full_body : WorkoutSplit.push_pull_legs;
    if (days == 4) return WorkoutSplit.upper_lower;
    return WorkoutSplit.push_pull_legs;
  }

  static _TrainingParameters getParametersForGoal(String goal, String level) {
    if (goal == 'lose_weight') return _TrainingParameters(sets: 3, reps: 12, restSeconds: 45);
    if (goal == 'build_muscle') return _TrainingParameters(sets: 4, reps: level == ExperienceLevel.beginner.name ? 10 : 12, restSeconds: 90);
    return _TrainingParameters(sets: 3, reps: 8, restSeconds: 120);
  }

  static WeeklyPlanModel generatePlan({required UserModel user, required List<ExerciseModel> exercisePool}) {
    final split = determineSplit(user);
    final params = getParametersForGoal(user.goal, user.experienceLevel);
    final List<DailyWorkoutModel> weekSchedule = [];
    final Map<String, String> splitMapping = _getSplitMapping(split, user.trainingDaysPerWeek);

    for (String day in daysOfWeek) {
      final focus = splitMapping[day]!;
      final bool isRest = focus == 'Rest';
      List<ExerciseSetModel> dailyExercises = [];
      if (!isRest) {
        for (String muscle in _getMuscleGroupsForFocus(focus)) {
          final selected = ExerciseSelector.selectForMuscleGroup(availableExercises: exercisePool, muscleGroup: muscle, count: 2);
          for (var ex in selected) {
            dailyExercises.add(ExerciseSetModel(exerciseId: ex.id, sets: params.sets, reps: params.reps, weightKg: ex.equipment == Equipment.bodyweight.name ? null : 10.0, restSeconds: params.restSeconds));
          }
        }
      }
      weekSchedule.add(DailyWorkoutModel(dayName: day, focus: focus, exercises: dailyExercises, isRestDay: isRest));
    }
    return WeeklyPlanModel(id: DateTime.now().millisecondsSinceEpoch.toString(), generatedAt: DateTime.now(), weekSchedule: weekSchedule);
  }

  static Map<String, String> _getSplitMapping(WorkoutSplit split, int days) {
    final map = {for (var d in daysOfWeek) d: 'Rest'};
    if (split == WorkoutSplit.full_body) {
      if (days >= 1) map['Wednesday'] = 'Full Body';
      if (days >= 2) { map['Monday'] = 'Full Body'; map['Thursday'] = 'Full Body'; }
    } else if (split == WorkoutSplit.upper_lower) {
      map['Monday'] = 'Upper Body'; map['Tuesday'] = 'Lower Body'; map['Thursday'] = 'Upper Body'; map['Friday'] = 'Lower Body';
    } else if (split == WorkoutSplit.push_pull_legs) {
      map['Monday'] = 'Push'; map['Tuesday'] = 'Pull'; map['Wednesday'] = 'Legs';
      if (days >= 4) map['Thursday'] = 'Push';
      if (days >= 5) map['Friday'] = 'Pull';
      if (days >= 6) map['Saturday'] = 'Legs';
    }
    return map;
  }

  static List<String> _getMuscleGroupsForFocus(String focus) {
    switch (focus) {
      case 'Push': return [MuscleGroup.chest.name, MuscleGroup.shoulders.name];
      case 'Pull': return [MuscleGroup.back.name, MuscleGroup.arms.name];
      case 'Legs': return [MuscleGroup.legs.name, MuscleGroup.core.name];
      case 'Upper Body': return [MuscleGroup.chest.name, MuscleGroup.back.name, MuscleGroup.shoulders.name, MuscleGroup.arms.name];
      case 'Lower Body': return [MuscleGroup.legs.name, MuscleGroup.core.name];
      case 'Full Body': return [MuscleGroup.chest.name, MuscleGroup.back.name, MuscleGroup.legs.name];
      default: return [MuscleGroup.full_body.name];
    }
  }
}

class _TrainingParameters {
  final int sets, reps, restSeconds;
  _TrainingParameters({required this.sets, required this.reps, required this.restSeconds});
}
