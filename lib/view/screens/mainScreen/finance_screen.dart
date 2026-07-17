import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/transaction.dart';
import 'package:poultry_pro/view_model/finance_period_provider.dart';
import 'package:poultry_pro/view_model/filtered_transactions_provider.dart';
import 'package:poultry_pro/view_model/finance_summary_provider.dart';
import 'package:poultry_pro/view/widgets/finance_header.dart';
import 'package:poultry_pro/view/widgets/expense_row.dart';
import 'package:poultry_pro/view/widgets/list_card.dart';
import 'package:poultry_pro/view/widgets/pl_summary_card.dart';
import 'package:poultry_pro/view/widgets/source_row.dart';
import 'package:poultry_pro/view/widgets/transaction_row.dart';
import 'package:poultry_pro/view/widgets/add_transaction_form.dart';

class Finance extends ConsumerStatefulWidget {
  const Finance({super.key});

  @override
  ConsumerState<Finance> createState() => _FinanceState();
}

class _FinanceState extends ConsumerState<Finance> {
  bool _showAdd = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final period = ref.watch(financePeriodProvider);
    final transactions = ref.watch(filteredTransactionsProvider);
    final summary = ref.watch(financeSummaryProvider);

    final incomeTx = transactions
        .where((t) => t.type == TransactionType.income)
        .toList();
    final expenseTx = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();

    final revenueByCategory = <String, double>{};
    for (final t in incomeTx) {
      revenueByCategory[t.category] =
          (revenueByCategory[t.category] ?? 0) + t.amount;
    }

    final expenseByCategory = <String, double>{};
    for (final t in expenseTx) {
      expenseByCategory[t.category] =
          (expenseByCategory[t.category] ?? 0) + t.amount;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _showAdd = !_showAdd),
        child: Icon(_showAdd ? Icons.close : Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FinanceHeader(
                onChanged: (i) => ref
                    .read(financePeriodProvider.notifier)
                    .setPeriod(FinancePeriod.values[i]),
                selectedIndex: FinancePeriod.values.indexOf(period),
              ),
              if (_showAdd)
                AddTransactionForm(
                  onCancel: () => setState(() => _showAdd = false),
                  onSave: () => setState(() => _showAdd = false),
                ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PLSummaryCard(
                      title: '${periodLabel(period)} . P&L',
                      rows: [
                        PLRowData(
                          'Revenue',
                          "GHS ${summary.revenue.toStringAsFixed(0)}",
                          summary.revenue == 0
                              ? 0.0
                              : summary.revenue /
                                    (summary.revenue + summary.expenses).clamp(
                                      1,
                                      double.infinity,
                                    ),
                          Theme.of(context).colorScheme.tertiary,
                        ),
                        PLRowData(
                          'Expenses',
                          "GHS ${summary.expenses.toStringAsFixed(0)}",
                          summary.expenses == 0
                              ? 0.0
                              : summary.expenses /
                                    (summary.revenue + summary.expenses).clamp(
                                      1,
                                      double.infinity,
                                    ),
                          Theme.of(context).colorScheme.error,
                        ),
                        PLRowData(
                          'Net Profit',
                          "GHS ${summary.netProfit.toStringAsFixed(0)}",
                          summary.revenue == 0
                              ? 0.0
                              : (summary.netProfit / summary.revenue).clamp(
                                  0,
                                  1,
                                ),
                          Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Revenue Sources",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    revenueByCategory.isEmpty
                        ? const _EmptySectionMessage(
                            message: 'No income recorded yet',
                          )
                        : ListCard(
                            rows: revenueByCategory.entries.map((e) {
                              final pct = summary.revenue == 0
                                  ? 0
                                  : (e.value / summary.revenue * 100).round();
                              return SourceRow(
                                icon: iconForCategory(e.key),
                                title: e.key,
                                subtitle: '$pct% of revenue',
                                value: 'GHS ${e.value.toStringAsFixed(0)}',
                              );
                            }).toList(),
                          ),
                    SizedBox(height: screenHeight * 0.04),
                    Text(
                      "Expenses",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    expenseByCategory.isEmpty
                        ? const _EmptySectionMessage(
                            message: 'No expenses recorded yet',
                          )
                        : ListCard(
                            rows: expenseByCategory.entries.map((e) {
                              final maxExpense = expenseByCategory.values
                                  .reduce((a, b) => a > b ? a : b);
                              return ExpenseRow(
                                icon: iconForCategory(e.key),
                                title: e.key,
                                value: 'GHS ${e.value.toStringAsFixed(0)}',
                                barPct: maxExpense == 0
                                    ? 0
                                    : e.value / maxExpense,
                              );
                            }).toList(),
                          ),
                    SizedBox(height: screenHeight * 0.04),
                    Text(
                      "Transactions",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    transactions.isEmpty
                        ? const _EmptySectionMessage(
                            message: 'No transactions recorded yet',
                          )
                        : ListCard(
                            rows: transactions.map((t) {
                              return TransactionRow(
                                icon: iconForCategory(t.category),
                                title: t.category,
                                date:
                                    '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}-${t.date.day.toString().padLeft(2, '0')}',
                                amount: 'GHS ${t.amount.toStringAsFixed(0)}',
                                isIncome: t.type == TransactionType.income,
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySectionMessage extends StatelessWidget {
  final String message;
  const _EmptySectionMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.scrim,
          fontSize: 13,
        ),
      ),
    );
  }
}
