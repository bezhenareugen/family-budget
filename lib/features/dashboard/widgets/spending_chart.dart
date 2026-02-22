import 'package:family_budget/core/models/app_currency.dart';
import 'package:family_budget/data/models/category.dart';
import 'package:family_budget/data/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/l10n/app_localizations.dart';

class SpendingChart extends StatefulWidget {
  final List<Transaction> transactions;
  final List<Category> categories;
  final AppCurrency currency;

  const SpendingChart({
    super.key,
    required this.transactions,
    required this.categories,
    required this.currency,
  });

  @override
  State<SpendingChart> createState() => _SpendingChartState();
}

class _SpendingChartState extends State<SpendingChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    // Group spending by category
    final Map<String, double> categorySpending = {};
    for (final t in widget.transactions) {
      categorySpending.update(
        t.categoryId,
        (v) => v + t.amount,
        ifAbsent: () => t.amount,
      );
    }

    if (categorySpending.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.spendingByCategory,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 160,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = response
                                  .touchedSection!
                                  .touchedSectionIndex;
                            });
                          },
                        ),
                        sections:
                            _buildSections(categorySpending, theme),
                        centerSpaceRadius: 32,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildLegend(
                        categorySpending, theme),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(
    Map<String, double> data,
    ThemeData theme,
  ) {
    final total = data.values.fold(0.0, (s, v) => s + v);
    final entries = data.entries.toList();

    return entries.asMap().entries.map((mapEntry) {
      final i = mapEntry.key;
      final entry = mapEntry.value;
      final isTouched = i == touchedIndex;
      final cat = widget.categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => Category(
          id: '',
          name: '?',
          icon: Icons.help,
          color: Colors.grey,
        ),
      );

      final pct = (entry.value / total * 100).round();
      final section = PieChartSectionData(
        value: entry.value,
        color: cat.color,
        title: isTouched ? '$pct%' : '',
        radius: isTouched ? 60 : 50,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
      return section;
    }).toList();
  }

  List<Widget> _buildLegend(
    Map<String, double> data,
    ThemeData theme,
  ) {
    return data.entries.map((entry) {
      final cat = widget.categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => Category(
          id: '',
          name: '?',
          icon: Icons.help,
          color: Colors.grey,
        ),
      );

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: cat.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                cat.name,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
