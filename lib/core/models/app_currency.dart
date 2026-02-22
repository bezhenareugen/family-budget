class AppCurrency {
  final String code;
  final String symbol;
  final String name;
  final String locale;

  const AppCurrency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.locale,
  });

  static const usd = AppCurrency(
    code: 'USD',
    symbol: '\$',
    name: 'US Dollar',
    locale: 'en_US',
  );

  static const eur = AppCurrency(
    code: 'EUR',
    symbol: '€',
    name: 'Euro',
    locale: 'de_DE',
  );

  static const mdl = AppCurrency(
    code: 'MDL',
    symbol: 'L',
    name: 'Moldovan Leu',
    locale: 'ro_MD',
  );

  static const uah = AppCurrency(
    code: 'UAH',
    symbol: '₴',
    name: 'Ukrainian Hryvnia',
    locale: 'uk_UA',
  );

  static const List<AppCurrency> all = [usd, eur, mdl, uah];

  static AppCurrency fromCode(String code) {
    return all.firstWhere(
      (c) => c.code == code,
      orElse: () => usd,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCurrency && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}
