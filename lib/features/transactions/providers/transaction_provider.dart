import 'package:family_budget/data/models/transaction.dart';
import 'package:family_budget/data/repositories/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

final transactionsProvider = NotifierProvider<TransactionNotifier,
    AsyncValue<List<Transaction>>>(TransactionNotifier.new);

class TransactionNotifier extends Notifier<AsyncValue<List<Transaction>>> {
  late final TransactionRepository _repository;

  @override
  AsyncValue<List<Transaction>> build() {
    _repository = ref.watch(transactionRepositoryProvider);
    loadTransactions();
    return const AsyncValue.loading();
  }

  Future<void> loadTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final transactions = await _repository.getTransactions(
        startDate: startDate,
        endDate: endDate,
        categoryId: categoryId,
      );
      state = AsyncValue.data(transactions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> addTransaction(Transaction transaction) async {
    try {
      await _repository.addTransaction(transaction);
      await loadTransactions();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateTransaction(Transaction transaction) async {
    try {
      await _repository.updateTransaction(transaction);
      await loadTransactions();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);
      await loadTransactions();
      return true;
    } catch (_) {
      return false;
    }
  }
}
