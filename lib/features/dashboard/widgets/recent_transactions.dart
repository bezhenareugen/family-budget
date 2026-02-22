import 'package:family_budget/core/models/app_currency.dart';
import 'package:family_budget/core/utils/currency_formatter.dart';
import 'package:family_budget/data/models/category.dart';
import 'package:family_budget/data/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;
  final List<Category> categories;
  final AppCurrency currency;

  const RecentTransactions({
    super.key,
    required this.transactions,
    required this.categories,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.recentTransactions,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/transactions'),
              child: Text(l.seeAll),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (transactions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  l.noTransactionsYet,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 56),
              itemBuilder: (context, index) {
                final t = transactions[index];
                final cat = categories.firstWhere(
                  (c) => c.id == t.categoryId,
                  orElse: () => Category(
                    id: '',
                    name: '?',
                    icon: Icons.help,
                    color: Colors.grey,
                  ),
                );
                final isIncome = t.type == TransactionType.income;

                return ListTile(
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
                    t.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(cat.name),
                  trailing: Text(
                    '${isIncome ? '+' : '-'}${CurrencyFormatter.format(t.amount, currency)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
