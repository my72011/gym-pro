import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction_category.dart';
import '../../services/transaction_service.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/custom_numpad.dart';

class QuickAddScreen extends StatefulWidget {
  const QuickAddScreen({super.key});

  @override
  State<QuickAddScreen> createState() => _QuickAddScreenState();
}

class _QuickAddScreenState extends State<QuickAddScreen> {
  final TransactionService _service = TransactionService.instance;
  
  // ValueNotifier GUARANTEES UI updates
  final ValueNotifier<String> _amountNotifier = ValueNotifier('0');
  
  TransactionCategory _category = TransactionCategory.food;
  final TextEditingController _noteCtrl = TextEditingController();

  double get _amount {
    final v = double.tryParse(_amountNotifier.value);
    return v ?? 0;
  }

  bool get _isValid => _amount > 0;

  void _onKey(NumpadKey key) {
    String newValue = _amountNotifier.value;
    
    switch (key) {
      case NumpadKey.backspace:
        if (newValue.length <= 1) {
          newValue = '0';
        } else {
          newValue = newValue.substring(0, newValue.length - 1);
        }
        break;
      case NumpadKey.dot:
        if (!newValue.contains('.')) {
          newValue = newValue == '0' ? '0.' : '$newValue.';
        }
        break;
      case NumpadKey.zero:
      case NumpadKey.one:
      case NumpadKey.two:
      case NumpadKey.three:
      case NumpadKey.four:
      case NumpadKey.five:
      case NumpadKey.six:
      case NumpadKey.seven:
      case NumpadKey.eight:
      case NumpadKey.nine:
        final digit = key.name.replaceAll(RegExp(r'\D'), '');
        if (newValue == '0') {
          newValue = digit;
        } else {
          final dot = newValue.indexOf('.');
          if (dot != -1 && newValue.length - dot - 1 >= 2) return;
          if (newValue.length >= 10) return;
          newValue = '$newValue$digit';
        }
        break;
    }
    
    // This GUARANTEES the UI will update
    _amountNotifier.value = newValue;
  }

  Future<void> _confirm() async {
    if (!_isValid) return;
    await _service.addExpense(
      amount: _amount,
      category: _category,
      title: _category.label,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _amountNotifier.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('New expense', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        actions: [
          ValueListenableBuilder<String>(
            valueListenable: _amountNotifier,
            builder: (context, value, _) {
              final isValid = (double.tryParse(value) ?? 0) > 0;
              return TextButton(
                onPressed: isValid ? _confirm : null,
                child: Text('Done', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isValid ? AppColors.primaryStart : AppColors.textTertiary)),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG, vertical: AppConstants.spaceLG),
              child: Column(
                children: [
                  const Text('Amount', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                  const SizedBox(height: AppConstants.spaceSM),
                  // ValueListenableBuilder GUARANTEES this updates
                  ValueListenableBuilder<String>(
                    valueListenable: _amountNotifier,
                    builder: (context, value, _) {
                      final amount = double.tryParse(value) ?? 0;
                      return Text(
                        CurrencyFormatter.format(amount),
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.02),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: TransactionCategory.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppConstants.spaceSM),
                  itemBuilder: (context, i) {
                    final c = TransactionCategory.values[i];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryChip(
                          category: c,
                          selected: c == _category,
                          onTap: () => setState(() => _category = c),
                        ),
                        const SizedBox(height: 6),
                        Text(c.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textTertiary), overflow: TextOverflow.ellipsis),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLG),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  color: AppColors.surfaceGlassStrong,
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceMD),
                child: TextField(
                  controller: _noteCtrl,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.edit_note_rounded, color: AppColors.textSecondary, size: 20),
                    hintText: 'Add a note (optional)',
                    hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            const Spacer(),
            CustomNumpad(onKey: _onKey, height: 320),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppConstants.spaceLG, 0, AppConstants.spaceLG, AppConstants.spaceLG),
              child: ValueListenableBuilder<String>(
                valueListenable: _amountNotifier,
                builder: (context, value, _) {
                  final amount = double.tryParse(value) ?? 0;
                  final isValid = amount > 0;
                  return GestureDetector(
                    onTap: isValid ? _confirm : null,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                        gradient: isValid ? const LinearGradient(colors: AppColors.primaryGradient) : null,
                        color: isValid ? null : AppColors.surfaceGlassStrong,
                        border: Border.all(color: AppColors.border),
                        boxShadow: isValid ? [BoxShadow(color: AppColors.primaryStart.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))] : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isValid ? 'Pay ${CurrencyFormatter.format(amount)}' : 'Enter amount',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isValid ? Colors.white : AppColors.textTertiary),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
