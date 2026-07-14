import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized typography.
class AppText {
  AppText._();

  static TextStyle get _base => GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.01,
      );

  // Display (balance)
  static TextStyle get display => GoogleFonts.manrope(
        color: AppColors.textPrimary,
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.03,
        height: 1.05,
      );

  static TextStyle get displaySmall => GoogleFonts.manrope(
        color: AppColors.textPrimary,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
        height: 1.1,
      );

  // Headings
  static TextStyle get h1 => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
      );

  static TextStyle get h2 => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01,
      );

  static TextStyle get h3 => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  // Body
  static TextStyle get body => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  // Caption
  static TextStyle get caption => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
        letterSpacing: 0.02,
      );

  // Mono (for amounts)
  static TextStyle get amount => GoogleFonts.manrope(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01,
      );

  static TextStyle get amountLarge => GoogleFonts.manrope(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
      );
}