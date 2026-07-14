import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'services/storage_service.dart';
import 'services/transaction_service.dart';
import 'screens/balance/balance_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await StorageService.instance.init();
  await TransactionService.instance.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Preload fonts so the first frame is smooth.
  await GoogleFonts.pendingFonts([
    GoogleFonts.inter(),
    GoogleFonts.manrope(),
  ]);

  runApp(const ZenBudgetApp());
}

class ZenBudgetApp extends StatelessWidget {
  const ZenBudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const BalanceScreen(),
    );
  }
}