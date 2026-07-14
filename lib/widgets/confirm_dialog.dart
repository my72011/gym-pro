import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_constants.dart';

/// Standard confirmation dialog for destructive actions.
///
/// Returns `true` only when the user confirms.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = true,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: AppText.h2),
      content: Text(message, style: AppText.bodySmall),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel,
              style: AppText.body.copyWith(color: AppColors.textSecondary)),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: isDestructive
                ? AppColors.danger
                : AppColors.primaryStart,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMD,
                vertical: AppConstants.spaceSM),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusSM)),
          ),
          child: Text(confirmLabel, style: AppText.body),
        ),
      ],
    );
  }
}