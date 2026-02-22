import 'package:family_budget/core/providers/currency_provider.dart';
import 'package:family_budget/data/models/transaction.dart';
import 'package:family_budget/features/categories/providers/category_provider.dart';
import 'package:family_budget/features/transactions/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:family_budget/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddEditTransactionScreen extends ConsumerStatefulWidget {
  final String? transactionId;

  const AddEditTransactionScreen({super.key, this.transactionId});

  @override
  ConsumerState<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  String? _categoryId;
  DateTime _date = DateTime.now();
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) {
      _isEdit = true;
      // Load existing transaction data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final transactions = ref.read(transactionsProvider).value;
        if (transactions != null) {
          final t = transactions.firstWhere(
            (t) => t.id == widget.transactionId,
          );
          setState(() {
            _type = t.type;
            _amountController.text = t.amount.toStringAsFixed(2);
            _descriptionController.text = t.description;
            _categoryId = t.categoryId;
            _date = t.date;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(categoriesProvider);
    final currency = ref.watch(currencyProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l.editTransaction : l.addTransaction),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Type toggle
            Text(l.type, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<TransactionType>(
              segments: [
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text(l.expenses),
                  icon: const Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text(l.income),
                  icon: const Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (v) => setState(() => _type = v.first),
            ),
            const SizedBox(height: 20),

            // Amount
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: l.amount,
                prefixText: '${currency.symbol} ',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                final n = double.tryParse(v);
                if (n == null || n <= 0) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l.description,
                hintText: l.addDescription,
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.date),
              subtitle: Text(DateFormat.yMMMd().format(_date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() => _date = picked);
                }
              },
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Category
            Text(
              l.category,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            categoriesAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (categories) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final isSelected = _categoryId == cat.id;
                  return FilterChip(
                    selected: isSelected,
                    label: Text(cat.name),
                    avatar: Icon(cat.icon,
                        color: isSelected ? null : cat.color, size: 18),
                    onSelected: (_) =>
                        setState(() => _categoryId = cat.id),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Submit
            FilledButton.icon(
              onPressed: _submit,
              icon: Icon(_isEdit ? Icons.check : Icons.add),
              label: Text(_isEdit ? l.save : l.addTransaction),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)!.selectCategory),
        ),
      );
      return;
    }

    final transaction = Transaction(
      id: _isEdit ? widget.transactionId! : const Uuid().v4(),
      amount: double.parse(_amountController.text),
      description: _descriptionController.text.trim(),
      categoryId: _categoryId!,
      date: _date,
      type: _type,
      createdAt: DateTime.now(),
    );

    if (_isEdit) {
      ref.read(transactionsProvider.notifier).updateTransaction(transaction);
    } else {
      ref.read(transactionsProvider.notifier).addTransaction(transaction);
    }

    Navigator.of(context).pop();
  }
}
