import 'package:family_budget/core/models/app_currency.dart';
import 'package:family_budget/core/providers/currency_provider.dart';
import 'package:family_budget/core/utils/currency_formatter.dart';
import 'package:family_budget/data/models/category.dart';
import 'package:family_budget/data/models/transaction.dart';
import 'package:family_budget/features/categories/providers/category_provider.dart';
import 'package:family_budget/features/transactions/providers/transaction_provider.dart';
import 'package:family_budget/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final transactionsAsync = ref.watch(transactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final currency = ref.watch(currencyProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.transactions),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/categories'),
            icon: const Icon(Icons.category, size: 18),
            label: Text(l.categories),
          ),
        ],
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long,
              title: l.noTransactionsYet,
              subtitle: l.startTracking,
              actionLabel: l.addTransaction,
              onAction: () => context.push('/transaction/add'),
            );
          }

          // Group by date
          final grouped = <String, List<Transaction>>{};
          for (final t in transactions) {
            final key = DateFormat.yMMMd().format(t.date);
            grouped.putIfAbsent(key, () => []).add(t);
          }

          final categories = categoriesAsync.value ?? [];

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: grouped.length,
            itemBuilder: (context, groupIndex) {
              final day = grouped.keys.elementAt(groupIndex);
              final items = grouped[day]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      day,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...items.map((t) => _TransactionTile(
                        transaction: t,
                        categories: categories,
                        currency: currency,
                        onDismissed: () {
                          ref
                              .read(transactionsProvider.notifier)
                              .deleteTransaction(t.id);
                        },
                        onTap: () {
                          context.push('/transaction/edit/${t.id}');
                        },
                      )),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transaction/add'),
        icon: const Icon(Icons.add),
        label: Text(l.addTransaction),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final List<Category> categories;
  final AppCurrency currency;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  const _TransactionTile({
    required this.transaction,
    required this.categories,
    required this.currency,
    required this.onDismissed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cat = categories.firstWhere(
      (c) => c.id == transaction.categoryId,
      orElse: () => Category(
        id: '',
        name: '?',
        icon: Icons.help,
        color: Colors.grey,
      ),
    );
    final isIncome = transaction.type == TransactionType.income;

    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colorScheme.errorContainer,
        child: Icon(
          Icons.delete,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l.deleteTransaction),
            content: Text(l.deleteTransactionConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.delete),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDismissed(),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cat.color.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(cat.icon, color: cat.color, size: 20),
        ),
        title: Text(
          transaction.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(cat.name),
        trailing: Text(
          '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount, currency)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
