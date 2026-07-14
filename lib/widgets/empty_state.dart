import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_constants.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceGlassStrong,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, size: 32, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppConstants.spaceMD),
            Text(title, style: AppText.h3, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: AppConstants.spaceXS),
              Text(subtitle!,
                  style: AppText.bodySmall, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}