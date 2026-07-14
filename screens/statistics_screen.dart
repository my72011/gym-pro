import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/progress_provider.dart';
import '../statistics/streak_calculator.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final logsAsync = ref.watch(progressLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error')),
        data: (logs) {
          final streak = StreakCalculator.calculateCurrentStreak(logs);
          final weightLogs = logs.where((l) => l.weightKg != null).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: theme.colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange, size: 40),
                            const SizedBox(height: 8),
                            Text('$streak', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const Text('Day Streak'),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 40),
                            const SizedBox(height: 8),
                            Text('${logs.where((l) => l.workoutCompleted).length}', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const Text('Total Workouts'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text('Weight Progress', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                
                SizedBox(
                  height: 250,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: weightLogs.isEmpty
                          ? const Center(child: Text('Log weight in Settings.'))
                          : LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(show: false),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _getSpots(weightLogs),
                                    isCurved: true,
                                    color: theme.colorScheme.primary,
                                    barWidth: 4,
                                    dotData: const FlDotData(show: true),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: theme.colorScheme.primary.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<FlSpot> _getSpots(List<dynamic> weightLogs) {
    List<FlSpot> spots = [];
    for (int i = 0; i < weightLogs.length; i++) {
      spots.add(FlSpot(i.toDouble(), weightLogs[i].weightKg!));
    }
    return spots;
  }
}