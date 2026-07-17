import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/transaction.dart';
import 'filtered_transactions_provider.dart';

final financeSummaryProvider =
    Provider<({double revenue, double expenses, double netProfit})>((ref) {
      final transactions = ref.watch(filteredTransactionsProvider);
      final revenue = transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);

      final expenses = transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);

      return (
        revenue: revenue,
        expenses: expenses,
        netProfit: revenue - expenses,
      );
    });
