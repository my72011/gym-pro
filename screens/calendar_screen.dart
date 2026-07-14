import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(userProvider).currentPlan;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Calendar')),
      body: plan == null
          ? const Center(child: Text('No plan generated yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: plan.weekSchedule.length,
              itemBuilder: (context, index) {
                final day = plan.weekSchedule[index];
                final isToday = _getTodayName() == day.dayName;
                
                return Card(
                  color: isToday ? theme.colorScheme.primaryContainer : null,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: day.isRestDay ? Colors.grey : theme.colorScheme.primary,
                      child: Icon(
                        day.isRestDay ? Icons.bedtime : Icons.fitness_center,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      day.dayName,
                      style: TextStyle(fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
                    ),
                    subtitle: Text(day.focus),
                    trailing: day.isRestDay
                        ? const Chip(label: Text('Rest'))
                        : Text('${day.exercises.length} Exercises'),
                  ),
                );
              },
            ),
    );
  }

  String _getTodayName() {
    final now = DateTime.now();
    return now.weekday == 7
        ? 'Sunday'
        : ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][now.weekday - 1];
  }
}