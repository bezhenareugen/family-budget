import 'package:family_budget/data/models/budget.dart';
import 'package:family_budget/data/remote/api_service.dart';

class BudgetRepository {
  final ApiService _api;

  BudgetRepository(this._api);

  Future<List<Budget>> getBudgets({int? month, int? year}) async {
    final params = <String, dynamic>{};
    if (month != null) params['month'] = month;
    if (year != null) params['year'] = year;

    return _api.get<List<Budget>>(
      '/api/budgets',
      queryParams: params,
      fromJson: (json) => (json as List)
          .map((j) => Budget.fromJson(j as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Budget> addBudget(Budget budget) async {
    return _api.post<Budget>(
      '/api/budgets',
      body: {
        'categoryId': budget.categoryId,
        'limit': budget.limit,
        'spent': budget.spent,
        'month': budget.month,
        'year': budget.year,
      },
      fromJson: (json) => Budget.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Budget> updateBudget(Budget budget) async {
    return _api.put<Budget>(
      '/api/budgets/${budget.id}',
      body: {
        'categoryId': budget.categoryId,
        'limit': budget.limit,
        'spent': budget.spent,
        'month': budget.month,
        'year': budget.year,
      },
      fromJson: (json) => Budget.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> deleteBudget(String id) => _api.delete('/api/budgets/$id');
}
