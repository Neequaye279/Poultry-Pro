import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/transaction.dart';
import 'transaction_provider.dart';
import 'finance_period_provider.dart';

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(transactionProvider);
  final period = ref.watch(financePeriodProvider);
  final now = DateTime.now();

  return transactions.where((t) {
    switch (period) {
      case FinancePeriod.daily:
        return t.date.year == now.year &&
            t.date.month == now.month &&
            t.date.day == now.day;
      case FinancePeriod.weekly:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfWeekDate = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );
        return !t.date.isBefore(startOfWeekDate);
      case FinancePeriod.monthly:
        return t.date.year == now.year && t.date.month == now.month;
    }
  }).toList();
});
