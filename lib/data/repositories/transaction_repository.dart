import 'package:family_budget/data/mock/mock_api_service.dart';
import 'package:family_budget/data/models/transaction.dart';

class TransactionRepository {
  final MockApiService _apiService = MockApiService();

  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) {
    return _apiService.getTransactions(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
    );
  }

  Future<Transaction> addTransaction(Transaction transaction) {
    return _apiService.addTransaction(transaction);
  }

  Future<Transaction> updateTransaction(Transaction transaction) {
    return _apiService.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String id) {
    return _apiService.deleteTransaction(id);
  }
}
