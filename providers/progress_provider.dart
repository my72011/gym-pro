import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/progress_model.dart';
import 'repository_providers.dart';

// This file ONLY handles the logs provider. 
// The progressRepositoryProvider and progressBoxProvider are kept in repository_providers.dart to avoid conflicts.
final progressLogsProvider = FutureProvider<List<ProgressLog>>((ref) async => await ref.watch(progressRepositoryProvider).getAllLogs());