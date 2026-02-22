// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Family Budget';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get name => 'Name';

  @override
  String get fullName => 'Full Name';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get loginSubtitle => 'Manage your family finances';

  @override
  String get createAccount => 'Create Account';

  @override
  String get registerSubtitle => 'Start managing your budget today';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get transactions => 'Transactions';

  @override
  String get budgets => 'Budgets';

  @override
  String get settings => 'Settings';

  @override
  String hello(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get manageFinances => 'Manage your family finances';

  @override
  String get refresh => 'Refresh';

  @override
  String get add => 'Add';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get income => 'Income';

  @override
  String get expenses => 'Expenses';

  @override
  String get spendingByCategory => 'Spending by Category';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get seeAll => 'See All';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get startTracking => 'Start tracking your income and expenses';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get deleteTransactionConfirm =>
      'This transaction will be permanently removed.';

  @override
  String get type => 'Type';

  @override
  String get amount => 'Amount';

  @override
  String get description => 'Description';

  @override
  String get date => 'Date';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get addDescription => 'What was this for?';

  @override
  String get categories => 'Categories';

  @override
  String get noCategories => 'No categories';

  @override
  String get addCategoriesSubtitle =>
      'Add categories to organize your transactions';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String deleteCategoryConfirm(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get categoryName => 'Category Name';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get noBudgets => 'No budgets set';

  @override
  String get setBudgetSubtitle => 'Set spending limits for your categories';

  @override
  String get addBudget => 'Add Budget';

  @override
  String get editBudgetLimit => 'Edit Budget Limit';

  @override
  String get deleteBudget => 'Delete Budget';

  @override
  String get deleteBudgetConfirm => 'Remove this budget limit?';

  @override
  String get monthlyLimit => 'Monthly Limit';

  @override
  String get over => 'Over';

  @override
  String percentUsed(int percent) {
    return '$percent% used';
  }

  @override
  String remaining(String amount) {
    return 'Remaining: $amount';
  }

  @override
  String spentOfLimit(String spent, String limit) {
    return '$spent of $limit';
  }

  @override
  String budgetsMonth(String month) {
    return 'Budgets — $month';
  }

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get general => 'General';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageAlerts => 'Manage alerts';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get english => 'English';

  @override
  String get romanian => 'Română';

  @override
  String get russian => 'Русский';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectCurrency => 'Select Currency';
}
