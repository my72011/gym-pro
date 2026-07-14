import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.blur = 18,
    this.opacity = 0.08,
    this.borderRadius,
    this.border,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppConstants.radiusLG);
    final resolvedBorder = border ?? const BorderSide(color: AppColors.border);

    final content = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppConstants.spaceMD),
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: resolvedBorder.color, width: resolvedBorder.width),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceGlass.withOpacity(opacity * 2),
            AppColors.surfaceGlass.withOpacity(opacity * 0.5),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child,
        ),
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: content,
      ),
    );
  }
}