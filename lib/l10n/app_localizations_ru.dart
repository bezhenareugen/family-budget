// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Семейный бюджет';

  @override
  String get login => 'Вход';

  @override
  String get register => 'Регистрация';

  @override
  String get email => 'Эл. почта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get name => 'Имя';

  @override
  String get fullName => 'Полное имя';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get signUp => 'Зарегистрироваться';

  @override
  String get signIn => 'Войти';

  @override
  String get loginSubtitle => 'Управляйте семейными финансами';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get registerSubtitle => 'Начните управлять бюджетом сегодня';

  @override
  String get dashboard => 'Главная';

  @override
  String get transactions => 'Транзакции';

  @override
  String get budgets => 'Бюджеты';

  @override
  String get settings => 'Настройки';

  @override
  String hello(String name) {
    return 'Привет, $name 👋';
  }

  @override
  String get manageFinances => 'Управляйте семейными финансами';

  @override
  String get refresh => 'Обновить';

  @override
  String get add => 'Добавить';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get totalBalance => 'Общий баланс';

  @override
  String get income => 'Доходы';

  @override
  String get expenses => 'Расходы';

  @override
  String get spendingByCategory => 'Расходы по категориям';

  @override
  String get recentTransactions => 'Последние транзакции';

  @override
  String get seeAll => 'Все';

  @override
  String get noTransactionsYet => 'Пока нет транзакций';

  @override
  String get startTracking => 'Начните отслеживать доходы и расходы';

  @override
  String get addTransaction => 'Добавить транзакцию';

  @override
  String get editTransaction => 'Редактировать транзакцию';

  @override
  String get deleteTransaction => 'Удалить транзакцию';

  @override
  String get deleteTransactionConfirm =>
      'Эта транзакция будет удалена навсегда.';

  @override
  String get type => 'Тип';

  @override
  String get amount => 'Сумма';

  @override
  String get description => 'Описание';

  @override
  String get date => 'Дата';

  @override
  String get category => 'Категория';

  @override
  String get selectCategory => 'Выберите категорию';

  @override
  String get addDescription => 'Для чего это было?';

  @override
  String get categories => 'Категории';

  @override
  String get noCategories => 'Нет категорий';

  @override
  String get addCategoriesSubtitle =>
      'Добавьте категории для организации транзакций';

  @override
  String get addCategory => 'Добавить категорию';

  @override
  String get editCategory => 'Редактировать категорию';

  @override
  String get deleteCategory => 'Удалить категорию';

  @override
  String deleteCategoryConfirm(String name) {
    return 'Удалить «$name»? Это нельзя отменить.';
  }

  @override
  String get categoryName => 'Название категории';

  @override
  String get icon => 'Иконка';

  @override
  String get color => 'Цвет';

  @override
  String get noBudgets => 'Бюджеты не заданы';

  @override
  String get setBudgetSubtitle => 'Установите лимиты расходов для категорий';

  @override
  String get addBudget => 'Добавить бюджет';

  @override
  String get editBudgetLimit => 'Редактировать лимит';

  @override
  String get deleteBudget => 'Удалить бюджет';

  @override
  String get deleteBudgetConfirm => 'Удалить этот лимит бюджета?';

  @override
  String get monthlyLimit => 'Месячный лимит';

  @override
  String get over => 'Превышен';

  @override
  String percentUsed(int percent) {
    return '$percent% использовано';
  }

  @override
  String remaining(String amount) {
    return 'Остаток: $amount';
  }

  @override
  String spentOfLimit(String spent, String limit) {
    return '$spent из $limit';
  }

  @override
  String budgetsMonth(String month) {
    return 'Бюджеты — $month';
  }

  @override
  String get appearance => 'Внешний вид';

  @override
  String get theme => 'Тема';

  @override
  String get systemTheme => 'Системная';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get general => 'Общие';

  @override
  String get language => 'Язык';

  @override
  String get currency => 'Валюта';

  @override
  String get notifications => 'Уведомления';

  @override
  String get manageAlerts => 'Управление оповещениями';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get about => 'О приложении';

  @override
  String get appVersion => 'Версия приложения';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get logout => 'Выйти';

  @override
  String get logoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get english => 'English';

  @override
  String get romanian => 'Română';

  @override
  String get russian => 'Русский';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get selectCurrency => 'Выберите валюту';
}
