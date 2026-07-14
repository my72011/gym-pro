import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _format = NumberFormat.currency(
    locale: 'en_US',
    symbol: AppConstants.currencySymbol,
    decimalDigits: AppConstants.maxFractionDigits,
  );

  static String format(double value) => _format.format(value);

  static String formatCompact(double value) {
    if (value.abs() >= 1000) {
      return '${AppConstants.currencySymbol}${(value / 1000).toStringAsFixed(1)}k';
    }
    return format(value);
  }

  static String formatSigned(double value) {
    final prefix = value >= 0 ? '+' : '-';
    return '$prefix${format(value.abs())}';
  }
}