enum TransactionType { income, expense }

class Transaction {
  final String id;
  final TransactionType type;
  final String category;
  final double amount;
  final DateTime date;
  final String? note;

  const Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });
}

enum FinancePeriod { daily, weekly, monthly }

String periodLabel(FinancePeriod period) {
  switch (period) {
    case FinancePeriod.daily:
      return 'TODAY';
    case FinancePeriod.weekly:
      return 'THIS WEEK';
    case FinancePeriod.monthly:
      return 'THIS MONTH';
  }
}
