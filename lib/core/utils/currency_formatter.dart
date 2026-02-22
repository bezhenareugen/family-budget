import 'package:family_budget/core/models/app_currency.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount, AppCurrency currency) {
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
      locale: currency.locale,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, AppCurrency currency) {
    if (amount.abs() >= 1000000) {
      return '${currency.symbol}${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1000) {
      return '${currency.symbol}${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount, currency);
  }

  static String formatSigned(double amount, AppCurrency currency) {
    final prefix = amount >= 0 ? '+' : '';
    return '$prefix${format(amount, currency)}';
  }
}
