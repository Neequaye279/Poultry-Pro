import 'package:poultry_pro/data/database_helper.dart';
import 'package:poultry_pro/model/transaction.dart';

class TransactionRepository {
  final _dbHelper = DatabaseHelper.instance;

  Map<String, dynamic> _toRow(Transaction t) {
    return {
      'id': t.id,
      'type': t.type.name,
      'category': t.category,
      'amount': t.amount,
      'date': t.date.toIso8601String(),
      'note': t.note,
    };
  }

  Transaction _fromRow(Map<String, dynamic> row) {
    return Transaction(
      id: row['id'] as String,
      type: TransactionType.values.byName(row['type'] as String),
      category: row['category'] as String,
      amount: row['amount'] as double,
      date: DateTime.parse(row['date'] as String),
      note: row['note'] as String?,
    );
  }

  Future<List<Transaction>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query('transactions', orderBy: 'date DESC');
    return rows.map(_fromRow).toList();
  }

  Future<void> insert(Transaction transaction) async {
    final db = await _dbHelper.database;
    await db.insert('transactions', _toRow(transaction));
  }

  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
