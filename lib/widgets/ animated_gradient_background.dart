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
    return Stack(
      children: [
        const ColoredBox(color: AppColors.background),
        TweenAnimationBuilder<BoxDecoration>(
          tween: BoxDecorationTween(end: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.3, -0.6),
              radius: 1.2,
              colors: colors.map((c) => c.withOpacity(0.55)).toList(),
            ),
          )),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          builder: (context, value, _) => DecoratedBox(decoration: value),
        ),
        TweenAnimationBuilder<BoxDecoration>(
          tween: BoxDecorationTween(end: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.8, 1.1),
              radius: 1.1,
              colors: [colors.last.withOpacity(0.35), Colors.transparent],
            ),
          )),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
          builder: (context, value, _) => DecoratedBox(decoration: value),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0x66000000)],
              stops: [0.4, 1.0],
            ),
          ),
        ),
        if (child != null) Positioned.fill(child: child!),
      ],
    );
  }
}

class BoxDecorationTween extends Tween<BoxDecoration> {
  BoxDecorationTween({super.begin, super.end});
  @override
  BoxDecoration lerp(double t) => BoxDecoration.lerp(begin, end, t)!;
}