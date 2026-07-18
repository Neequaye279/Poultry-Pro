import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultry_pro/data/transaction_repository.dart';
import 'package:poultry_pro/model/transaction.dart';

class TransactionNotifier extends AsyncNotifier<List<Transaction>> {
  final _repo = TransactionRepository();

  @override
  Future<List<Transaction>> build() async {
    return _repo.getAll();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final previous = await future;
    state = AsyncData([...previous, transaction]);
    try {
      await _repo.insert(transaction);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    final previous = await future;
    state = AsyncData(previous.where((t) => t.id != id).toList());
    try {
      await _repo.delete(id);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }
}

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, List<Transaction>>(
      TransactionNotifier.new,
    );
