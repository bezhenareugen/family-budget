import 'package:family_budget/core/providers/currency_provider.dart';
import 'package:family_budget/data/models/transaction.dart';
import 'package:family_budget/features/auth/providers/auth_provider.dart';
import 'package:family_budget/features/categories/providers/category_provider.dart';
import 'package:family_budget/features/dashboard/widgets/balance_card.dart';
import 'package:family_budget/features/dashboard/widgets/recent_transactions.dart';
import 'package:family_budget/features/dashboard/widgets/spending_chart.dart';
import 'package:family_budget/features/transactions/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final currency = ref.watch(currencyProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.hello(authState.user?.name.split(' ').first ?? 'User'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l.manageFinances,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: false,
        toolbarHeight: 72,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(transactionsProvider.notifier).loadTransactions();
            },
            icon: const Icon(Icons.refresh),
            tooltip: l.refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(transactionsProvider.notifier)
              .loadTransactions();
        },
        child: transactionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (transactions) {
            final totalIncome = transactions
                .where((t) => t.type == TransactionType.income)
                .fold(0.0, (sum, t) => sum + t.amount);
            final totalExpenses = transactions
                .where((t) => t.type == TransactionType.expense)
                .fold(0.0, (sum, t) => sum + t.amount);
            final balance = totalIncome - totalExpenses;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BalanceCard(
                  balance: balance,
                  income: totalIncome,
                  expenses: totalExpenses,
                  currency: currency,
                ),
                const SizedBox(height: 20),
                categoriesAsync.when(
                  data: (categories) => SpendingChart(
                    transactions: transactions
                        .where((t) => t.type == TransactionType.expense)
                        .toList(),
                    categories: categories,
                    currency: currency,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                categoriesAsync.when(
                  data: (categories) => RecentTransactions(
                    transactions: transactions.take(5).toList(),
                    categories: categories,
                    currency: currency,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transaction/add'),
        icon: const Icon(Icons.add),
        label: Text(l.add),
      ),
    );
  }
}
