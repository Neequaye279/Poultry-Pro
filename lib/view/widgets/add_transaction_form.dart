import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import 'package:poultry_pro/model/transaction.dart';
import 'package:poultry_pro/view_model/transaction_provider.dart';
import 'finance_form_controls.dart';

const revenueCategories = [
  'Egg Sales',
  'Bird Sales',
  'Manure Sales',
  'Other Income',
];
const expenseCategories = [
  'Feed',
  'Vaccines',
  'Labour',
  'Utilities',
  'Equipment',
  'Other Expense',
];

const Map<String, IconData> categoryIcons = {
  'Egg Sales': LucideIcons.egg,
  'Bird Sales': LucideIcons.feather,
  'Manure Sales': LucideIcons.recycle,
  'Other Income': LucideIcons.plusCircle,
  'Feed': LucideIcons.wheat,
  'Vaccines': LucideIcons.syringe,
  'Labour': LucideIcons.user,
  'Utilities': LucideIcons.zap,
  'Equipment': LucideIcons.wrench,
  'Other Expense': LucideIcons.minusCircle,
};

IconData iconForCategory(String category) =>
    categoryIcons[category] ?? LucideIcons.circleDollarSign;

class AddTransactionForm extends ConsumerStatefulWidget {
  const AddTransactionForm({
    super.key,
    required this.onCancel,
    required this.onSave,
  });
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  ConsumerState<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<AddTransactionForm> {
  bool _isIncome = true;
  String _category = revenueCategories.first;
  final _amountCtrl = TextEditingController();
  final _dateCtrl = TextEditingController(
    text: DateTime.now().toIso8601String().substring(0, 10),
  );
  final _noteCtrl = TextEditingController();

  String? _amountError;
  String? _dateError;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _dateCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _switchType(int index) {
    setState(() {
      _isIncome = index == 0;
      _category = _isIncome ? revenueCategories.first : expenseCategories.first;
    });
  }

  void _submit() {
    final amt = double.tryParse(_amountCtrl.text);
    setState(() {
      _amountError = (amt == null || amt <= 0) ? 'Enter a valid amount' : null;
      _dateError = _dateCtrl.text.isEmpty ? 'Pick a date' : null;
    });
    if (_amountError != null || _dateError != null) return;

    final parsedDate = DateTime.tryParse(_dateCtrl.text) ?? DateTime.now();

    final transaction = Transaction(
      id: const Uuid().v4(),
      type: _isIncome ? TransactionType.income : TransactionType.expense,
      category: _category,
      amount: amt!,
      date: parsedDate,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );

    ref.read(transactionProvider.notifier).addTransaction(transaction);

    _amountCtrl.clear();
    _noteCtrl.clear();
    setState(() {
      _isIncome = true;
      _category = revenueCategories.first;
      _dateCtrl.text = DateTime.now().toIso8601String().substring(0, 10);
    });

    widget.onSave();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final options = _isIncome ? revenueCategories : expenseCategories;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          bottom: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              GestureDetector(
                onTap: widget.onCancel,
                child: Icon(LucideIcons.x, size: 17, color: cs.scrim),
              ),
            ],
          ),
          SizedBox(height: 11),
          SegmentedTabs(
            labels: const ['Income', 'Expense'],
            selectedIndex: _isIncome ? 0 : 1,
            onChanged: _switchType,
            activeColors: [cs.tertiary, cs.error],
          ),
          SizedBox(height: 13),
          FormFieldSelect(
            label: 'Category',
            value: _category,
            options: options,
            onChanged: (v) => setState(() => _category = v),
          ),
          FormFieldInput(
            label: 'Amount (GHS)',
            placeholder: 'e.g. 450',
            icon: LucideIcons.dollarSign,
            controller: _amountCtrl,
            errorText: _amountError,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          FormFieldInput(
            label: 'Date',
            placeholder: 'YYYY-MM-DD',
            icon: LucideIcons.calendar,
            controller: _dateCtrl,
            errorText: _dateError,
          ),
          FormFieldInput(
            label: 'Note',
            placeholder: 'Optional details',
            icon: LucideIcons.info,
            controller: _noteCtrl,
            optional: true,
          ),
          SizedBox(height: 4),
          Row(
            children: [
              PrimaryButton(
                label: 'Cancel',
                onTap: widget.onCancel,
                outline: true,
              ),
              SizedBox(width: 8),
              PrimaryButton(label: 'Save', onTap: _submit),
            ],
          ),
        ],
      ),
    );
  }
}
