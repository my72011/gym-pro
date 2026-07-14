import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryStart,
        secondary: AppColors.primaryEnd,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      textTheme: TextTheme(
        displayLarge: AppText.display,
        displayMedium: AppText.displaySmall,
        headlineLarge: AppText.h1,
        headlineMedium: AppText.h2,
        titleLarge: AppText.h3,
        bodyLarge: AppText.body,
        bodyMedium: AppText.bodySmall,
        labelSmall: AppText.caption,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
        ),
      ),
      dividerColor: AppColors.border,
      // FIX: Changed DialogTheme to DialogThemeData
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
        titleTextStyle: AppText.h2,
        contentTextStyle: AppText.body,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      useMaterial3: true,
    );
  }
}