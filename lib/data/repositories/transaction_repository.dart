import 'package:family_budget/data/local/local_storage_service.dart';
import 'package:family_budget/data/models/transaction.dart';
import 'package:uuid/uuid.dart';

class TransactionRepository {
  final LocalStorageService _storage;
  static const _uuid = Uuid();

  TransactionRepository(this._storage);

  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    final jsonList = _storage.getTransactions();
    var transactions = jsonList.map((j) => Transaction.fromJson(j)).toList();

    if (startDate != null) {
      transactions = transactions.where((t) => !t.date.isBefore(startDate)).toList();
    }
    if (endDate != null) {
      transactions = transactions.where((t) => !t.date.isAfter(endDate)).toList();
    }
    if (categoryId != null) {
      transactions = transactions.where((t) => t.categoryId == categoryId).toList();
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  Future<Transaction> addTransaction(Transaction transaction) async {
    final newTransaction = transaction.copyWith(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
    );

    final jsonList = _storage.getTransactions();
    jsonList.add(newTransaction.toJson());
    await _storage.saveTransactions(jsonList);

    return newTransaction;
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    final jsonList = _storage.getTransactions();
    final index = jsonList.indexWhere((j) => j['id'] == transaction.id);
    if (index == -1) throw Exception('Transaction not found');

    jsonList[index] = transaction.toJson();
    await _storage.saveTransactions(jsonList);
    return transaction;
  }

  Future<void> deleteTransaction(String id) async {
    final jsonList = _storage.getTransactions();
    jsonList.removeWhere((j) => j['id'] == id);
    await _storage.saveTransactions(jsonList);
  }
}
