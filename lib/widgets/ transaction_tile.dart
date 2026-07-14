import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/date_formatter.dart';
import '../models/transaction.dart';
import 'category_chip.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap, this.onDelete, this.showDate = true});

  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceMD, vertical: AppConstants.spaceSM),
          child: Row(
            children: [
              CategoryChip(category: transaction.category, compact: true),
              const SizedBox(width: AppConstants.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.title, style: AppText.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(transaction.category.label, style: AppText.caption),
                        if (transaction.note != null && transaction.note!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          const Text('•', style: TextStyle(color: AppColors.textTertiary)),
                          const SizedBox(width: 6),
                          Expanded(child: Text(transaction.note!, style: AppText.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ] else
                          const Spacer(),
                        if (showDate) Text(DateFormatter.relative(transaction.createdAt), style: AppText.caption),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.spaceMD),
              Text('-${CurrencyFormatter.format(transaction.amount)}', style: AppText.amount.copyWith(color: AppColors.danger)),
            ],
          ),
        ),
      ),
    );
  }
}