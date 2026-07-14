import 'package:flutter/material.dart';

/// Premium color palette for Zen Budget.
///
/// All colors are desaturated, calm, and designed for dark surfaces.
class AppColors {
  AppColors._();

  // --- Surfaces ---
  static const Color background = Color(0xFF0B0D12);
  static const Color surface = Color(0xFF12151C);
  static const Color surfaceElevated = Color(0xFF1A1E27);
  static const Color surfaceGlass = Color(0x14FFFFFF); // ~8% white
  static const Color surfaceGlassStrong = Color(0x22FFFFFF); // ~13% white

  // --- Text ---
  static const Color textPrimary = Color(0xFFF4F6FA);
  static const Color textSecondary = Color(0xFF9AA3B2);
  static const Color textTertiary = Color(0xFF5E6676);

  // --- Primary gradient (Blue → Purple) ---
  static const Color primaryStart = Color(0xFF5B8DEF);
  static const Color primaryEnd = Color(0xFF9B6BEA);

  static const List<Color> primaryGradient = [primaryStart, primaryEnd];

  // --- Semantic ---
  static const Color success = Color(0xFF4ADE80);
  static const Color successSoft = Color(0xFF1F3A2A);
  static const Color warning = Color(0xFFFBBF5A);
  static const Color warningSoft = Color(0xFF3A2E1A);
  static const Color danger = Color(0xFFF87171);
  static const Color dangerSoft = Color(0xFF3A1F24);

  // --- Balance-reactive gradients ---
  static const List<Color> positiveGradient = [
    Color(0xFF1E3A8A), // deep blue
    Color(0xFF4338CA), // indigo
    Color(0xFF6D28D9), // violet
  ];

  static const List<Color> lowGradient = [
    Color(0xFF7C2D12), // deep orange
    Color(0xFF9A3412),
    Color(0xFFB45309),
  ];

  static const List<Color> negativeGradient = [
    Color(0xFF7F1D1D), // deep red
    Color(0xFF991B1B),
    Color(0xFFB91C1C),
  ];

  // --- Borders ---
  static const Color border = Color(0x14FFFFFF);
  static const Color borderStrong = Color(0x22FFFFFF);
}