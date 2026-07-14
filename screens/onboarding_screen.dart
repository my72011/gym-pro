import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/enums.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _gender = Gender.male.name;
  String _goal = Goal.maintain.name;
  String _experience = ExperienceLevel.beginner.name;
  String _location = WorkoutLocation.gym.name;
  int _daysPerWeek = 3;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        age: int.parse(_ageController.text),
        gender: _gender,
        heightCm: double.parse(_heightController.text),
        weightKg: double.parse(_weightController.text),
        goal: _goal,
        experienceLevel: _experience,
        trainingDaysPerWeek: _daysPerWeek,
        workoutLocation: _location,
        createdAt: DateTime.now(),
      );

      await ref.read(userProvider.notifier).saveUserAndGeneratePlan(user);
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Welcome to GymCoach Pro', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Let\'s build your personalized plan.', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 32),
                
                TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                
                Row(children: [
                  Expanded(child: TextFormField(controller: _ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 16),
                  Expanded(child: DropdownButtonFormField<String>(value: _gender, decoration: const InputDecoration(labelText: 'Gender'), items: Gender.values.map((g) => DropdownMenuItem(value: g.name, child: Text(g.name.capitalize))).toList(), onChanged: (v) => setState(() => _gender = v!))),
                ]),
                const SizedBox(height: 16),

                Row(children: [
                  Expanded(child: TextFormField(controller: _heightController, decoration: const InputDecoration(labelText: 'Height (cm)'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _weightController, decoration: const InputDecoration(labelText: 'Weight (kg)'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
                ]),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(value: _goal, decoration: const InputDecoration(labelText: 'Primary Goal'), items: Goal.values.map((g) => DropdownMenuItem(value: g.name, child: Text(g.name.replaceAll('_', ' ').capitalize))).toList(), onChanged: (v) => setState(() => _goal = v!)),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(value: _experience, decoration: const InputDecoration(labelText: 'Experience Level'), items: ExperienceLevel.values.map((e) => DropdownMenuItem(value: e.name, child: Text(e.name.capitalize))).toList(), onChanged: (v) => setState(() => _experience = v!)),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(value: _location, decoration: const InputDecoration(labelText: 'Workout Location'), items: WorkoutLocation.values.map((l) => DropdownMenuItem(value: l.name, child: Text(l.name.capitalize))).toList(), onChanged: (v) => setState(() => _location = v!)),
                const SizedBox(height: 16),

                Text('Training Days per Week: $_daysPerWeek', style: theme.textTheme.titleMedium),
                Slider(value: _daysPerWeek.toDouble(), min: 1, max: 7, divisions: 6, label: '$_daysPerWeek', onChanged: (v) => setState(() => _daysPerWeek = v.round())),
                const SizedBox(height: 32),

                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.fitness_center),
                  label: const Padding(padding: EdgeInsets.all(12.0), child: Text('Generate My Plan', style: TextStyle(fontSize: 16))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize => this[0].toUpperCase() + substring(1);
}