import 'package:family_budget/data/models/budget.dart';
import 'package:family_budget/data/repositories/budget_repository.dart';
import 'package:family_budget/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.watch(localStorageServiceProvider));
});

final budgetsProvider =
    NotifierProvider<BudgetNotifier, AsyncValue<List<Budget>>>(
        BudgetNotifier.new);

class BudgetNotifier extends Notifier<AsyncValue<List<Budget>>> {
  late final BudgetRepository _repository;

  @override
  AsyncValue<List<Budget>> build() {
    _repository = ref.watch(budgetRepositoryProvider);
    loadBudgets();
    return const AsyncValue.loading();
  }

  Future<void> loadBudgets({int? month, int? year}) async {
    state = const AsyncValue.loading();
    try {
      final now = DateTime.now();
      final budgets = await _repository.getBudgets(
        month: month ?? now.month,
        year: year ?? now.year,
      );
      state = AsyncValue.data(budgets);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> addBudget(Budget budget) async {
    try {
      await _repository.addBudget(budget);
      await loadBudgets();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateBudget(Budget budget) async {
    try {
      await _repository.updateBudget(budget);
      await loadBudgets();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteBudget(String id) async {
    try {
      await _repository.deleteBudget(id);
      await loadBudgets();
      return true;
    } catch (_) {
      return false;
    }
  }
}
