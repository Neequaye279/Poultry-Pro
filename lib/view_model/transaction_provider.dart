import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/model/transaction.dart';

class TransactionNotifier extends Notifier<List<Transaction>> {
  @override
  List<Transaction> build() => [];

  void addTransaction(Transaction transaction) {
    state = [...state, transaction];
  }

  void deleteTransaction(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}

final transactionProvider =
    NotifierProvider<TransactionNotifier, List<Transaction>>(
      TransactionNotifier.new,
    );
