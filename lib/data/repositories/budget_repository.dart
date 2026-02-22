import 'package:family_budget/data/mock/mock_api_service.dart';
import 'package:family_budget/data/models/budget.dart';

class BudgetRepository {
  final MockApiService _apiService = MockApiService();

  Future<List<Budget>> getBudgets({int? month, int? year}) {
    return _apiService.getBudgets(month: month, year: year);
  }

  Future<Budget> addBudget(Budget budget) {
    return _apiService.addBudget(budget);
  }

  Future<Budget> updateBudget(Budget budget) {
    return _apiService.updateBudget(budget);
  }

  Future<void> deleteBudget(String id) {
    return _apiService.deleteBudget(id);
  }
}
