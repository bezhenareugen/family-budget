// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appName => 'Bugetul Familiei';

  @override
  String get login => 'Autentificare';

  @override
  String get register => 'Înregistrare';

  @override
  String get email => 'Email';

  @override
  String get password => 'Parola';

  @override
  String get confirmPassword => 'Confirmă parola';

  @override
  String get name => 'Nume';

  @override
  String get fullName => 'Nume complet';

  @override
  String get dontHaveAccount => 'Nu ai cont?';

  @override
  String get alreadyHaveAccount => 'Ai deja un cont?';

  @override
  String get signUp => 'Înregistrează-te';

  @override
  String get signIn => 'Conectează-te';

  @override
  String get loginSubtitle => 'Gestionează finanțele familiei';

  @override
  String get createAccount => 'Creare cont';

  @override
  String get registerSubtitle => 'Începe să-ți gestionezi bugetul azi';

  @override
  String get dashboard => 'Panou';

  @override
  String get transactions => 'Tranzacții';

  @override
  String get budgets => 'Bugete';

  @override
  String get settings => 'Setări';

  @override
  String hello(String name) {
    return 'Salut, $name 👋';
  }

  @override
  String get manageFinances => 'Gestionează finanțele familiei';

  @override
  String get refresh => 'Reîmprospătare';

  @override
  String get add => 'Adaugă';

  @override
  String get cancel => 'Anulează';

  @override
  String get save => 'Salvează';

  @override
  String get delete => 'Șterge';

  @override
  String get edit => 'Editează';

  @override
  String get totalBalance => 'Sold total';

  @override
  String get income => 'Venituri';

  @override
  String get expenses => 'Cheltuieli';

  @override
  String get spendingByCategory => 'Cheltuieli pe categorii';

  @override
  String get recentTransactions => 'Tranzacții recente';

  @override
  String get seeAll => 'Vezi toate';

  @override
  String get noTransactionsYet => 'Nicio tranzacție încă';

  @override
  String get startTracking => 'Începe să urmărești veniturile și cheltuielile';

  @override
  String get addTransaction => 'Adaugă tranzacție';

  @override
  String get editTransaction => 'Editează tranzacția';

  @override
  String get deleteTransaction => 'Șterge tranzacția';

  @override
  String get deleteTransactionConfirm =>
      'Această tranzacție va fi eliminată definitiv.';

  @override
  String get type => 'Tip';

  @override
  String get amount => 'Sumă';

  @override
  String get description => 'Descriere';

  @override
  String get date => 'Data';

  @override
  String get category => 'Categorie';

  @override
  String get selectCategory => 'Selectează o categorie';

  @override
  String get addDescription => 'Pentru ce a fost?';

  @override
  String get categories => 'Categorii';

  @override
  String get noCategories => 'Nicio categorie';

  @override
  String get addCategoriesSubtitle =>
      'Adaugă categorii pentru a organiza tranzacțiile';

  @override
  String get addCategory => 'Adaugă categorie';

  @override
  String get editCategory => 'Editează categoria';

  @override
  String get deleteCategory => 'Șterge categoria';

  @override
  String deleteCategoryConfirm(String name) {
    return 'Ștergi „$name”? Nu se poate anula.';
  }

  @override
  String get categoryName => 'Numele categoriei';

  @override
  String get icon => 'Pictogramă';

  @override
  String get color => 'Culoare';

  @override
  String get noBudgets => 'Niciun buget setat';

  @override
  String get setBudgetSubtitle =>
      'Stabilește limite de cheltuieli pentru categorii';

  @override
  String get addBudget => 'Adaugă buget';

  @override
  String get editBudgetLimit => 'Editează limita bugetului';

  @override
  String get deleteBudget => 'Șterge buget';

  @override
  String get deleteBudgetConfirm => 'Elimini această limită de buget?';

  @override
  String get monthlyLimit => 'Limită lunară';

  @override
  String get over => 'Depășit';

  @override
  String percentUsed(int percent) {
    return '$percent% folosit';
  }

  @override
  String remaining(String amount) {
    return 'Rămas: $amount';
  }

  @override
  String spentOfLimit(String spent, String limit) {
    return '$spent din $limit';
  }

  @override
  String budgetsMonth(String month) {
    return 'Bugete — $month';
  }

  @override
  String get appearance => 'Aspect';

  @override
  String get theme => 'Temă';

  @override
  String get systemTheme => 'Sistem';

  @override
  String get lightTheme => 'Luminos';

  @override
  String get darkTheme => 'Întunecat';

  @override
  String get general => 'General';

  @override
  String get language => 'Limbă';

  @override
  String get currency => 'Monedă';

  @override
  String get notifications => 'Notificări';

  @override
  String get manageAlerts => 'Gestionează alertele';

  @override
  String get comingSoon => 'În curând';

  @override
  String get about => 'Despre';

  @override
  String get appVersion => 'Versiunea aplicației';

  @override
  String get termsOfService => 'Termeni și condiții';

  @override
  String get privacyPolicy => 'Politica de confidențialitate';

  @override
  String get logout => 'Deconectare';

  @override
  String get logoutConfirm => 'Ești sigur că vrei să te deconectezi?';

  @override
  String get english => 'English';

  @override
  String get romanian => 'Română';

  @override
  String get russian => 'Русский';

  @override
  String get selectLanguage => 'Selectează limba';

  @override
  String get selectCurrency => 'Selectează moneda';
}
