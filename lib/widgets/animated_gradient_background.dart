import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AnimatedGradientBackground extends StatelessWidget {
  const AnimatedGradientBackground({super.key, required this.balance, this.child});
  final double balance;
  final Widget? child;

  List<Color> _colorsFor(double b) {
    if (b < 0) return AppColors.negativeGradient;
    if (b < 100) return AppColors.lowGradient;
    return AppColors.positiveGradient;
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(balance);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.first.withOpacity(0.8),
            colors.last.withOpacity(0.4),
          ],
        ),
      ),
      child: child,
    );
  }
}
