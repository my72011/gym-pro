import 'package:hive/hive.dart';
import '../models/exercise_model.dart';

abstract class ExerciseRepository {
  Future<List<ExerciseModel>> getAllExercises();
  Future<ExerciseModel?> getExerciseById(String id);
  Future<void> addExercises(List<ExerciseModel> exercises);
  Future<bool> isDatabaseSeeded();
  Future<void> setDatabaseSeeded(bool value);
}

class ExerciseRepositoryImpl implements ExerciseRepository {
  final Box<ExerciseModel> _exerciseBox;
  final Box<bool> _settingsBox;

  ExerciseRepositoryImpl(this._exerciseBox, this._settingsBox);

  @override
  Future<List<ExerciseModel>> getAllExercises() async {
    return _exerciseBox.values.toList();
  }

  @override
  Future<ExerciseModel?> getExerciseById(String id) async {
    return _exerciseBox.get(id);
  }

  @override
  Future<void> addExercises(List<ExerciseModel> exercises) async {
    for (var ex in exercises) {
      await _exerciseBox.put(ex.id, ex);
    }
  }

  @override
  Future<bool> isDatabaseSeeded() async {
    return _settingsBox.get('is_seeded', defaultValue: false)!;
  }

  @override
  Future<void> setDatabaseSeeded(bool value) async {
    await _settingsBox.put('is_seeded', value);
  }
}