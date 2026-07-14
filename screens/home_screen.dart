import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../nutrition_engine/nutrition_calculator.dart';
import '../providers/user_provider.dart';
import '../providers/repository_providers.dart';
import 'exercise_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final exercisesAsync = ref.watch(allExercisesProvider);
    final theme = Theme.of(context);

    if (userState.isLoading || userState.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = userState.user!;
    final plan = userState.currentPlan;
    final nutrition = NutritionCalculator.calculate(user);
    
    final todayName = DateTime.now().weekday == 7 
        ? 'Sunday' 
        : ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][DateTime.now().weekday - 1];
        
    final todayWorkout = plan?.weekSchedule.firstWhere(
      (d) => d.dayName == todayName, 
      orElse: () => plan!.weekSchedule.first,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${user.name}!', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Nutrition', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatChip(label: 'Calories', value: '${nutrition.targetCalories}', unit: 'kcal', color: theme.colorScheme.primary),
                        _StatChip(label: 'Protein', value: '${nutrition.proteinGrams}', unit: 'g', color: Colors.red),
                        _StatChip(label: 'Carbs', value: '${nutrition.carbsGrams}', unit: 'g', color: Colors.orange),
                        _StatChip(label: 'Fat', value: '${nutrition.fatGrams}', unit: 'g', color: Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Today: ${todayWorkout?.dayName}', style: theme.textTheme.titleLarge),
                        Chip(label: Text(todayWorkout?.focus ?? 'Rest')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (todayWorkout == null || todayWorkout.isRestDay)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Rest Day! Recover and stretch.', style: TextStyle(fontSize: 18)),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: todayWorkout.exercises.length,
                        itemBuilder: (context, index) {
                          final set = todayWorkout.exercises[index];
                          final ex = exercisesAsync.value?.firstWhere((e) => e.id == set.exerciseId);
                          
                          return ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.fitness_center)),
                            title: Text(ex?.name ?? 'Exercise'),
                            subtitle: Text('${set.sets} sets x ${set.reps} reps | Rest: ${set.restSeconds}s'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              if (ex != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: ex)),
                                );
                              }
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value, unit;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
        Text(unit, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}