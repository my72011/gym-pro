import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'database/database_seeder.dart';
import 'models/user_model.dart';
import 'models/exercise_model.dart';
import 'models/workout_plan_model.dart';
import 'models/progress_model.dart';
import 'providers/repository_providers.dart';
import 'providers/user_provider.dart';
// FIX: Added missing import
import 'repositories/exercise_repository.dart';
import 'screens/onboarding_screen.dart';
import 'navigation/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ExerciseModelAdapter());
  Hive.registerAdapter(DailyWorkoutModelAdapter());
  Hive.registerAdapter(ExerciseSetModelAdapter());
  Hive.registerAdapter(WeeklyPlanModelAdapter());
  Hive.registerAdapter(ProgressLogAdapter());

  final userBox = await Hive.openBox<UserModel>('users');
  final exerciseBox = await Hive.openBox<ExerciseModel>('exercises');
  final settingsBox = await Hive.openBox<bool>('settings');
  final planBox = await Hive.openBox<WeeklyPlanModel>('weekly_plans');
  final progressBox = await Hive.openBox<ProgressLog>('progress_logs');

  final seeder = DatabaseSeeder(ExerciseRepositoryImpl(exerciseBox, settingsBox));
  await seeder.seedIfNecessary();

  runApp(ProviderScope(
    overrides: [
      userBoxProvider.overrideWithValue(userBox),
      exerciseBoxProvider.overrideWithValue(exerciseBox),
      settingsBoxProvider.overrideWithValue(settingsBox),
      planBoxProvider.overrideWithValue(planBox),
      progressBoxProvider.overrideWithValue(progressBox),
    ],
    child: const GymCoachProApp(),
  ));
}

class GymCoachProApp extends ConsumerStatefulWidget {
  const GymCoachProApp({super.key});
  @override ConsumerState<GymCoachProApp> createState() => _GymCoachProAppState();
}

class _GymCoachProAppState extends ConsumerState<GymCoachProApp> {
  @override void initState() { super.initState(); Future.microtask(() => ref.read(userProvider.notifier).loadInitialData()); }

  @override Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    return MaterialApp(
      title: 'GymCoach Pro', debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, darkTheme: AppTheme.darkTheme, themeMode: ThemeMode.system,
      home: userState.isLoading ? const Scaffold(body: Center(child: CircularProgressIndicator())) : (userState.user == null ? const OnboardingScreen() : const MainShell()),
    );
  }
}