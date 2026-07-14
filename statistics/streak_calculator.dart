import '../models/progress_model.dart';

class StreakCalculator {
  /// Calculates the current consecutive days of working out
  static int calculateCurrentStreak(List<ProgressLog> logs) {
    final completedLogs = logs.where((l) => l.workoutCompleted).toList();
    if (completedLogs.isEmpty) return 0;

    completedLogs.sort((a, b) => b.date.compareTo(a.date)); // Sort descending
    
    int streak = 0;
    DateTime expectedDate = DateTime.now();
    
    // Normalize to date only (ignore time)
    expectedDate = DateTime(expectedDate.year, expectedDate.month, expectedDate.day);

    for (var log in completedLogs) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);
      
      if (logDate == expectedDate || logDate == expectedDate.subtract(const Duration(days: 1))) {
        streak++;
        expectedDate = logDate;
      } else {
        break;
      }
    }
    return streak;
  }
}