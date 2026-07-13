import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultry_pro/view/widgets/finance_header.dart';
import 'package:poultry_pro/view/widgets/expense_row.dart';
import 'package:poultry_pro/view/widgets/list_card.dart';
import 'package:poultry_pro/view/widgets/pl_summary_card.dart';
import 'package:poultry_pro/view/widgets/source_row.dart';
import 'package:poultry_pro/view/widgets/transaction_row.dart';
import 'package:poultry_pro/view/widgets/add_transaction_form.dart';

class Finance extends StatefulWidget {
  const Finance({super.key});

  @override
  State<Finance> createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  int _period = 2;
  bool _showAdd = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FinanceHeader(
                onTap: () => setState(() => _showAdd = true),
                onSecondTap: () {},
                onChanged: (i) => setState(() => _period = i),
                selectedIndex: _period,
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
                      title: 'THIS MONTH . P&L',
                      rows: [
                        PLRowData(
                          'Revenue',
                          "GHS 7,930",
                          1.0,
                          Theme.of(context).colorScheme.tertiary,
                        ),
                        PLRowData(
                          'Expenses',
                          "GHS 2,280",
                          0.29,
                          Theme.of(context).colorScheme.error,
                        ),
                        PLRowData(
                          'Net Profit',
                          "GHS 5,650",
                          0.71,
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
                    ListCard(
                      rows: [
                        SourceRow(
                          icon: LucideIcons.egg,
                          title: "Egg Sales",
                          subtitle: "68% of revenue",
                          value: "GHS 4,730",
                        ),
                        SourceRow(
                          icon: LucideIcons.feather,
                          title: "Bird Sales",
                          subtitle: "32% of revenue",
                          value: "GHS 3,200",
                        ),
                      ],
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
                    ListCard(
                      rows: [
                        ExpenseRow(
                          icon: LucideIcons.wheat,
                          title: 'Feed',
                          value: "GHS 1300",
                          barPct: 0.9,
                        ),
                        ExpenseRow(
                          icon: LucideIcons.syringe,
                          title: "Vaccines",
                          value: "GHS 680",
                          barPct: 0.5,
                        ),
                        ExpenseRow(
                          icon: LucideIcons.user,
                          title: "Labour",
                          value: "GHS 300",
                          barPct: 0.25,
                        ),
                      ],
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
                    ListCard(
                      rows: [
                        TransactionRow(
                          icon: LucideIcons.egg,
                          title: 'Egg Sales',
                          date: '2026-07-10',
                          amount: 'GHS 620',
                          isIncome: true,
                        ),
                        TransactionRow(
                          icon: LucideIcons.wheat,
                          title: 'Feed',
                          date: '2026-07-10',
                          amount: 'GHS 180',
                          isIncome: false,
                        ),
                        TransactionRow(
                          icon: LucideIcons.feather,
                          title: 'Bird Sales',
                          date: '2026-07-08',
                          amount: 'GHS 1,200',
                          isIncome: true,
                        ),
                        TransactionRow(
                          icon: LucideIcons.syringe,
                          title: 'Vaccines',
                          date: '2026-07-08',
                          amount: 'GHS 300',
                          isIncome: false,
                        ),
                        TransactionRow(
                          icon: LucideIcons.user,
                          title: 'Labour',
                          date: '2026-07-07',
                          amount: 'GHS 100',
                          isIncome: false,
                        ),
                      ],
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
