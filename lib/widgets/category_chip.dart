import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../models/transaction_category.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
    this.compact = false,
  });

  final TransactionCategory category;
  final bool selected;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 40.0 : 56.0;
    final iconSize = compact ? 18.0 : 24.0;

    final chip = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          color: selected
              ? category.color.withOpacity(0.22)
              : AppColors.surfaceGlassStrong,
          border: Border.all(
            color: selected ? category.color.withOpacity(0.6) : AppColors.border,
            width: 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: category.color.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Icon(category.icon, size: iconSize, color: category.color),
      ),
    );

    if (onTap == null) return chip;

    return GestureDetector(
      onTap: onTap,
      child: chip,
    );
  }
}

class AnimatedContainer extends StatelessWidget {
  const AnimatedContainer({
    super.key,
    required this.duration,
    required this.child,
  });

  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1.0,
      duration: duration,
      curve: Curves.easeOut,
      child: child,
    );
  }
}