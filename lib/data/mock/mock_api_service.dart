import 'package:family_budget/core/constants/app_constants.dart';
import 'package:family_budget/data/mock/mock_data.dart';
import 'package:family_budget/data/models/budget.dart';
import 'package:family_budget/data/models/category.dart';
import 'package:family_budget/data/models/transaction.dart';
import 'package:uuid/uuid.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._();
  factory MockApiService() => _instance;
  MockApiService._();

  final _uuid = const Uuid();

  // In-memory stores
  late List<Transaction> _transactions = List.from(MockData.transactions);
  late List<Category> _categories = List.from(MockData.categories);
  late List<Budget> _budgets = List.from(MockData.budgets);
  bool _initialized = false;

  void _ensureInitialized() {
    if (!_initialized) {
      _transactions = List.from(MockData.transactions);
      _categories = List.from(MockData.categories);
      _budgets = List.from(MockData.budgets);
      _initialized = true;
    }
  }

  // === Transactions ===

  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    var result = List<Transaction>.from(_transactions);

    if (startDate != null) {
      result = result.where((t) => !t.date.isBefore(startDate)).toList();
    }
    if (endDate != null) {
      result = result.where((t) => !t.date.isAfter(endDate)).toList();
    }
    if (categoryId != null) {
      result = result.where((t) => t.categoryId == categoryId).toList();
    }

    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  Future<Transaction> addTransaction(Transaction transaction) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    final newTransaction = transaction.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
    );
    _transactions.add(newTransaction);

    // Update budget spent if expense
    if (newTransaction.type == TransactionType.expense) {
      _updateBudgetSpent(newTransaction.categoryId, newTransaction.amount);
    }

    return newTransaction;
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index == -1) throw Exception('Transaction not found');

    _transactions[index] = transaction;
    return transaction;
  }

  Future<void> deleteTransaction(String id) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    _transactions.removeWhere((t) => t.id == id);
  }

  // === Categories ===

  Future<List<Category>> getCategories() async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);
    return List.from(_categories);
  }

  Future<Category> addCategory(Category category) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    final newCategory = category.copyWith(id: _uuid.v4());
    _categories.add(newCategory);
    return newCategory;
  }

  Future<Category> updateCategory(Category category) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index == -1) throw Exception('Category not found');

    _categories[index] = category;
    return category;
  }

  Future<void> deleteCategory(String id) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    _categories.removeWhere((c) => c.id == id);
  }

  // === Budgets ===

  Future<List<Budget>> getBudgets({int? month, int? year}) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    var result = List<Budget>.from(_budgets);
    if (month != null) {
      result = result.where((b) => b.month == month).toList();
    }
    if (year != null) {
      result = result.where((b) => b.year == year).toList();
    }
    return result;
  }

  Future<Budget> addBudget(Budget budget) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    final newBudget = budget.copyWith(id: _uuid.v4());
    _budgets.add(newBudget);
    return newBudget;
  }

  Future<Budget> updateBudget(Budget budget) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index == -1) throw Exception('Budget not found');

    _budgets[index] = budget;
    return budget;
  }

  Future<void> deleteBudget(String id) async {
    _ensureInitialized();
    await Future.delayed(AppConstants.apiDelay);

    _budgets.removeWhere((b) => b.id == id);
  }

  // Helper
  void _updateBudgetSpent(String categoryId, double amount) {
    final now = DateTime.now();
    final index = _budgets.indexWhere(
      (b) =>
          b.categoryId == categoryId &&
          b.month == now.month &&
          b.year == now.year,
    );
    if (index != -1) {
      _budgets[index] = _budgets[index].copyWith(
        spent: _budgets[index].spent + amount,
      );
    }
  }
}
