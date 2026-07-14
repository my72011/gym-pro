import 'package:hive/hive.dart';
import '../models/workout_plan_model.dart';

abstract class WorkoutRepository {
  Future<void> saveWeeklyPlan(WeeklyPlanModel plan);
  Future<WeeklyPlanModel?> getLatestPlan();
  Future<List<WeeklyPlanModel>> getAllPlans();
}

class WorkoutRepositoryImpl implements WorkoutRepository {
  final Box<WeeklyPlanModel> _planBox;

  WorkoutRepositoryImpl(this._planBox);

  @override
  Future<void> saveWeeklyPlan(WeeklyPlanModel plan) async {
    await _planBox.put(plan.id, plan);
  }

  @override
  Future<WeeklyPlanModel?> getLatestPlan() async {
    if (_planBox.isEmpty) return null;
    // Sort by generatedAt to get the latest
    final plans = _planBox.values.toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
    return plans.first;
  }

  @override
  Future<List<WeeklyPlanModel>> getAllPlans() async {
    final plans = _planBox.values.toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
    return plans;
  }
}