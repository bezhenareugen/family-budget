import 'package:family_budget/core/models/app_currency.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final currencyProvider =
    NotifierProvider<CurrencyNotifier, AppCurrency>(CurrencyNotifier.new);

class CurrencyNotifier extends Notifier<AppCurrency> {
  static const _key = 'currency_code';

  @override
  AppCurrency build() {
    _load();
    return AppCurrency.usd;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      state = AppCurrency.fromCode(code);
    }
  }

  Future<void> setCurrency(AppCurrency currency) async {
    state = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, currency.code);
  }
}
