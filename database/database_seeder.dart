import '../models/exercise_model.dart';
import '../repositories/exercise_repository.dart';

class DatabaseSeeder {
  final ExerciseRepository _exerciseRepo;

  DatabaseSeeder(this._exerciseRepo);

  Future<void> seedIfNecessary() async {
    final isSeeded = await _exerciseRepo.isDatabaseSeeded();
    if (isSeeded) return;

    final exercises = _generateDefaultExercises();
    await _exerciseRepo.addExercises(exercises);
    await _exerciseRepo.setDatabaseSeeded(true);
  }

  List<ExerciseModel> _generateDefaultExercises() {
    // Using placeholder HTTPS URLs. In a real app, these would be actual CDN links.
    return [
      // CHEST
      ExerciseModel(id: 'ex_1', name: 'Push-Ups', muscleGroup: 'chest', equipment: 'bodyweight', 
          imageUrl: 'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Keep your back straight and lower your chest to the floor.'),
      ExerciseModel(id: 'ex_2', name: 'Dumbbell Bench Press', muscleGroup: 'chest', equipment: 'dumbbell', 
          imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Press the dumbbells up over your chest, keeping your elbows at a 45-degree angle.'),
      ExerciseModel(id: 'ex_3', name: 'Barbell Bench Press', muscleGroup: 'chest', equipment: 'barbell', 
          imageUrl: 'https://images.unsplash.com/photo-1534368786749-b63e05c92717?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Lower the bar to your mid-chest and press back up explosively.'),

      // BACK
      ExerciseModel(id: 'ex_4', name: 'Pull-Ups', muscleGroup: 'back', equipment: 'bodyweight', 
          imageUrl: 'https://images.unsplash.com/photo-1598662972297-4292e213b55b?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Pull your chin over the bar, engaging your lats.'),
      ExerciseModel(id: 'ex_5', name: 'Dumbbell Rows', muscleGroup: 'back', equipment: 'dumbbell', 
          imageUrl: 'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Pull the dumbbell to your hip, keeping your back flat.'),
      ExerciseModel(id: 'ex_6', name: 'Barbell Deadlift', muscleGroup: 'back', equipment: 'barbell', 
          imageUrl: 'https://images.unsplash.com/photo-1517963879433-6ad2b056d712?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Keep the bar close to your body and drive through your heels.'),

      // LEGS
      ExerciseModel(id: 'ex_7', name: 'Bodyweight Squats', muscleGroup: 'legs', equipment: 'bodyweight', 
          imageUrl: 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Keep your chest up and sit back as if into a chair.'),
      ExerciseModel(id: 'ex_8', name: 'Goblet Squats', muscleGroup: 'legs', equipment: 'dumbbell', 
          imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Hold the dumbbell at chest height and squat deep.'),
      ExerciseModel(id: 'ex_9', name: 'Barbell Back Squat', muscleGroup: 'legs', equipment: 'barbell', 
          imageUrl: 'https://images.unsplash.com/photo-1566241142559-40e1dab266c6?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Rest the bar on your upper back, squat until thighs are parallel.'),

      // SHOULDERS
      ExerciseModel(id: 'ex_10', name: 'Pike Push-Ups', muscleGroup: 'shoulders', equipment: 'bodyweight', 
          imageUrl: 'https://images.unsplash.com/photo-1541534741688-6a154d9e5d5a?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Form an inverted V shape and press your head toward the floor.'),
      ExerciseModel(id: 'ex_11', name: 'Dumbbell Shoulder Press', muscleGroup: 'shoulders', equipment: 'dumbbell', 
          imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Press the weights directly overhead, fully extending your arms.'),

      // ARMS
      ExerciseModel(id: 'ex_12', name: 'Diamond Push-Ups', muscleGroup: 'arms', equipment: 'bodyweight', 
          imageUrl: 'https://images.unsplash.com/photo-1598971639058-fab3c3109a00?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Place hands close together forming a diamond, focus on triceps.'),
      ExerciseModel(id: 'ex_13', name: 'Dumbbell Bicep Curls', muscleGroup: 'arms', equipment: 'dumbbell', 
          imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Keep elbows tucked and curl the weights up, squeezing at the top.'),

      // CORE
      ExerciseModel(id: 'ex_14', name: 'Plank', muscleGroup: 'core', equipment: 'bodyweight', 
          imageUrl: 'https://images.unsplash.com/photo-1566241142559-40e1dab266c6?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Keep your body in a straight line, engage your core tightly.'),
      ExerciseModel(id: 'ex_15', name: 'Russian Twists', muscleGroup: 'core', equipment: 'bodyweight', 
          imageUrl: 'https://images.unsplash.com/photo-1541534741688-6a154d9e2155?w=500', 
          videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4', instructions: 'Lean back slightly, twist your torso from side to side.'),
    ];
  }
}