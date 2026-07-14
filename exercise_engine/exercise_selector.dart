import '../core/constants/enums.dart';
import '../models/exercise_model.dart';

class ExerciseSelector {
  static List<ExerciseModel> filterExercises({
    required List<ExerciseModel> allExercises, 
    required String workoutLocation, 
    required List<String> availableEquipment, 
    String? targetMuscleGroup
  }) {
    return allExercises.where((exercise) {
      bool locationMatch = workoutLocation == WorkoutLocation.home.name 
          ? ['bodyweight', 'dumbbell', 'kettlebell'].contains(exercise.equipment) 
          : true;
      bool equipmentMatch = availableEquipment.contains(exercise.equipment);
      bool muscleMatch = targetMuscleGroup == null || exercise.muscleGroup == targetMuscleGroup;
      return locationMatch && equipmentMatch && muscleMatch;
    }).toList();
  }

  static List<ExerciseModel> selectForMuscleGroup({
    required List<ExerciseModel> availableExercises, 
    required String muscleGroup, 
    required int count
  }) {
    final filtered = availableExercises.where((e) => e.muscleGroup == muscleGroup).toList();
    filtered.shuffle();
    return filtered.take(count).toList();
  }
}
