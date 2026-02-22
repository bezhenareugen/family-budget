import 'package:family_budget/data/models/transaction.dart';
import 'package:family_budget/data/remote/api_service.dart';

class TransactionRepository {
  final ApiService _api;

  TransactionRepository(this._api);

  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    final params = <String, dynamic>{};
    if (startDate != null) params['startDate'] = startDate.toIso8601String();
    if (endDate != null) params['endDate'] = endDate.toIso8601String();
    if (categoryId != null) params['categoryId'] = categoryId;

    return _api.get<List<Transaction>>(
      '/api/transactions',
      queryParams: params,
      fromJson: (json) => (json as List)
          .map((j) => Transaction.fromJson(_normalizeJson(j as Map<String, dynamic>)))
          .toList(),
    );
  }

  Future<Transaction> addTransaction(Transaction transaction) async {
    return _api.post<Transaction>(
      '/api/transactions',
      body: {
        'amount': transaction.amount,
        'type': transaction.type.name,
        'categoryId': transaction.categoryId,
        'description': transaction.description,
        'date': transaction.date.toIso8601String(),
      },
      fromJson: (json) => Transaction.fromJson(_normalizeJson(json as Map<String, dynamic>)),
    );
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    return _api.put<Transaction>(
      '/api/transactions/${transaction.id}',
      body: {
        'amount': transaction.amount,
        'type': transaction.type.name,
        'categoryId': transaction.categoryId,
        'description': transaction.description,
        'date': transaction.date.toIso8601String(),
      },
      fromJson: (json) => Transaction.fromJson(_normalizeJson(json as Map<String, dynamic>)),
    );
  }

  Future<void> deleteTransaction(String id) => _api.delete('/api/transactions/$id');

  // API returns lowercase type ('income'/'expense'), Flutter model uses enum name
  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> j) => {
        ...j,
        'type': (j['type'] as String).toLowerCase(),
      };
}
