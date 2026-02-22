import 'package:family_budget/data/local/local_storage_service.dart';
import 'package:family_budget/data/models/budget.dart';
import 'package:uuid/uuid.dart';

class BudgetRepository {
  final LocalStorageService _storage;
  static const _uuid = Uuid();

  BudgetRepository(this._storage);

  Future<List<Budget>> getBudgets({int? month, int? year}) async {
    final jsonList = _storage.getBudgets();
    var budgets = jsonList.map((j) => Budget.fromJson(j)).toList();

    if (month != null) {
      budgets = budgets.where((b) => b.month == month).toList();
    }
    if (year != null) {
      budgets = budgets.where((b) => b.year == year).toList();
    }

    return budgets;
  }

  Future<Budget> addBudget(Budget budget) async {
    final newBudget = budget.copyWith(id: _uuid.v4());

    final jsonList = _storage.getBudgets();
    jsonList.add(newBudget.toJson());
    await _storage.saveBudgets(jsonList);

    return newBudget;
  }

  Future<Budget> updateBudget(Budget budget) async {
    final jsonList = _storage.getBudgets();
    final index = jsonList.indexWhere((j) => j['id'] == budget.id);
    if (index == -1) throw Exception('Budget not found');

    jsonList[index] = budget.toJson();
    await _storage.saveBudgets(jsonList);
    return budget;
  }

  Future<void> deleteBudget(String id) async {
    final jsonList = _storage.getBudgets();
    jsonList.removeWhere((j) => j['id'] == id);
    await _storage.saveBudgets(jsonList);
  }
}
