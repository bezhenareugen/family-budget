import 'package:family_budget/core/providers/currency_provider.dart';
import 'package:family_budget/core/utils/currency_formatter.dart';
import 'package:family_budget/data/models/budget.dart';
import 'package:family_budget/data/models/category.dart';
import 'package:family_budget/features/budgets/providers/budget_provider.dart';
import 'package:family_budget/features/categories/providers/category_provider.dart';
import 'package:family_budget/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:family_budget/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final budgetsAsync = ref.watch(budgetsProvider);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.budgetsMonth(DateFormat.MMMM().format(now))),
      ),
      body: budgetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (budgets) {
          if (budgets.isEmpty) {
            return EmptyState(
              icon: Icons.pie_chart_outline,
              title: l.noBudgets,
              subtitle: l.setBudgetSubtitle,
              actionLabel: l.addBudget,
              onAction: () => _showAddBudgetDialog(context, ref),
            );
          }

          final categoriesAsync = ref.watch(categoriesProvider);
          final categories = categoriesAsync.value ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: budgets.length + 1,
            itemBuilder: (context, index) {
              if (index == budgets.length) {
                return const SizedBox(height: 80);
              }
              final budget = budgets[index];
              final cat = categories.firstWhere(
                (c) => c.id == budget.categoryId,
                orElse: () => Category(
                  id: '',
                  name: 'Unknown',
                  icon: Icons.help,
                  color: Colors.grey,
                ),
              );

              return _BudgetCard(
                budget: budget,
                category: cat,
                onEdit: () => _showEditBudgetDialog(context, ref, budget),
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l.deleteBudget),
                      content: Text(l.deleteBudgetConfirm),
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
                  if (confirm == true) {
                    ref
                        .read(budgetsProvider.notifier)
                        .deleteBudget(budget.id);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBudgetDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l.addBudget),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final categoriesAsync = ref.read(categoriesProvider);
    final categories = categoriesAsync.value ?? [];
    final currency = ref.read(currencyProvider);
    String? selectedCategoryId;
    final limitController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l.addBudget),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedCategoryId,
                decoration: InputDecoration(labelText: l.category),
                items: categories
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Row(
                            children: [
                              Icon(c.icon, color: c.color, size: 20),
                              const SizedBox(width: 8),
                              Text(c.name),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (v) =>
                    setDialogState(() => selectedCategoryId = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: limitController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: l.monthlyLimit,
                  prefixText: '${currency.symbol} ',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (selectedCategoryId == null ||
                    limitController.text.isEmpty) {
                  return;
                }
                final now = DateTime.now();
                ref.read(budgetsProvider.notifier).addBudget(
                      Budget(
                        id: '',
                        categoryId: selectedCategoryId!,
                        limit: double.parse(limitController.text),
                        spent: 0,
                        month: now.month,
                        year: now.year,
                      ),
                    );
                Navigator.pop(ctx);
              },
              child: Text(l.add),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBudgetDialog(
      BuildContext context, WidgetRef ref, Budget budget) {
    final l = AppLocalizations.of(context)!;
    final currency = ref.read(currencyProvider);
    final limitController =
        TextEditingController(text: budget.limit.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.editBudgetLimit),
        content: TextFormField(
          controller: limitController,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            labelText: l.monthlyLimit,
            prefixText: '${currency.symbol} ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (limitController.text.isEmpty) return;
              ref.read(budgetsProvider.notifier).updateBudget(
                    budget.copyWith(
                      limit: double.parse(limitController.text),
                    ),
                  );
              Navigator.pop(ctx);
            },
            child: Text(l.save),
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final Budget budget;
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final pct = budget.percentage;
    final isOver = budget.isOverBudget;

    return Consumer(
      builder: (context, ref, _) {
        final currency = ref.watch(currencyProvider);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: category.color.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(category.icon,
                            color: category.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              l.spentOfLimit(
                                CurrencyFormatter.format(budget.spent, currency),
                                CurrencyFormatter.format(budget.limit, currency),
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isOver)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l.over,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'edit') onEdit();
                          if (v == 'delete') onDelete();
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                              value: 'edit', child: Text(l.edit)),
                          PopupMenuItem(
                              value: 'delete', child: Text(l.delete)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: pct.clamp(0, 1),
                      minHeight: 8,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(
                        isOver ? theme.colorScheme.error : category.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l.percentUsed((pct * 100).round()),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isOver
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        l.remaining(CurrencyFormatter.format(
                            budget.remaining.clamp(0, double.infinity), currency)),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
