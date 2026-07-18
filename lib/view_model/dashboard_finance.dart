import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/transaction.dart';
import 'package:poultry_pro/view_model/filtered_transactions_provider.dart';
import 'package:poultry_pro/view_model/transaction_provider.dart';

final financeSummaryProvider =
    Provider<({double revenue, double expenses, double netProfit})>((ref) {
      final transactions = ref.watch(filteredTransactionsProvider);
      return _summarize(transactions);
    });

final monthlyFinanceSummaryProvider =
    Provider<({double revenue, double expenses, double netProfit})>((ref) {
      final allTransactions = ref.watch(transactionProvider);
      final now = DateTime.now();

      final monthly = allTransactions
          .where((t) => t.date.year == now.year && t.date.month == now.month)
          .toList();

      return _summarize(monthly);
    });

({double revenue, double expenses, double netProfit}) _summarize(
  List<Transaction> transactions,
) {
  final revenue = transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  final expenses = transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  return (revenue: revenue, expenses: expenses, netProfit: revenue - expenses);
}
