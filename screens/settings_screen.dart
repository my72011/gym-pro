import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/progress_model.dart';
import '../pdf_engine/pdf_generator.dart';
import '../providers/progress_provider.dart';
import '../providers/repository_providers.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _weightController = TextEditingController();
  bool _isExporting = false;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _logWeight() async {
    final weight = double.tryParse(_weightController.text);
    if (weight == null) return;

    await ref.read(progressRepositoryProvider).logProgress(
      ProgressLog(date: DateTime.now(), weightKg: weight, workoutCompleted: false),
    );
    
    ref.invalidate(progressLogsProvider);
    _weightController.clear();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Weight logged!')));
    }
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      final userState = ref.read(userProvider);
      final exercises = await ref.read(exerciseRepositoryProvider).getAllExercises();
      
      await PdfGenerator.generateAndShare(
        user: userState.user!,
        plan: userState.currentPlan!,
        exerciseLibrary: exercises,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _resetApp() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset App?'),
        content: const Text('Delete all data?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(userRepositoryProvider).deleteUser();
      ref.read(userProvider.notifier).loadInitialData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profile', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Name: ${user?.name ?? 'N/A'}'),
                    Text('Goal: ${user?.goal.replaceAll('_', ' ') ?? 'N/A'}'),
                    Text('Location: ${user?.workoutLocation ?? 'N/A'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Text('Log Today\'s Weight', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton.tonal(onPressed: _logWeight, child: const Icon(Icons.scale)),
              ],
            ),
            const SizedBox(height: 32),
            
            OutlinedButton.icon(
              onPressed: _isExporting ? null : _exportPdf,
              icon: _isExporting 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                  : const Icon(Icons.picture_as_pdf),
              label: Text(_isExporting ? 'Generating...' : 'Export Plan to PDF'),
            ),
            const SizedBox(height: 16),
            
            TextButton.icon(
              onPressed: _resetApp,
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text('Reset All Data', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}