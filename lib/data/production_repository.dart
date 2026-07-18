import 'package:poultry_pro/data/database_helper.dart';
import 'package:poultry_pro/model/production.dart';

class ProductionRepository {
  final _dbHelper = DatabaseHelper.instance;

  String _typeOf(Production p) => switch (p) {
    EggProduction() => 'egg',
    FeedProduction() => 'feed',
    VaccineProduction() => 'vaccine',
    MortalityProduction() => 'mortality',
  };

  Map<String, dynamic> _toRow(Production p) {
    final base = <String, dynamic>{
      'id': p.id,
      'type': _typeOf(p),
      'date': p.date.toIso8601String(),
      'collected': null,
      'broken': null,
      'amountAdded': null,
      'amountRemaining': null,
      'vaccineName': null,
      'dosesAdministered': null,
      'dosesWasted': null,
      'dead': null,
      'missing': null,
      'cause': null,
    };

    switch (p) {
      case EggProduction():
        base['collected'] = p.collected;
        base['broken'] = p.broken;
      case FeedProduction():
        base['amountAdded'] = p.amountAdded;
        base['amountRemaining'] = p.amountRemaining;
      case VaccineProduction():
        base['vaccineName'] = p.vaccineName;
        base['dosesAdministered'] = p.dosesAdministered;
        base['dosesWasted'] = p.dosesWasted;
      case MortalityProduction():
        base['dead'] = p.dead;
        base['missing'] = p.missing;
        base['cause'] = p.cause;
    }

    return base;
  }

  Production _fromRow(Map<String, dynamic> row) {
    final id = row['id'] as String;
    final date = DateTime.parse(row['date'] as String);

    switch (row['type'] as String) {
      case 'egg':
        return EggProduction(
          id: id,
          date: date,
          collected: row['collected'] as int,
          broken: row['broken'] as int,
        );
      case 'feed':
        return FeedProduction(
          id: id,
          date: date,
          amountAdded: row['amountAdded'] as double,
          amountRemaining: row['amountRemaining'] as double,
        );
      case 'vaccine':
        return VaccineProduction(
          id: id,
          date: date,
          vaccineName: row['vaccineName'] as String,
          dosesAdministered: row['dosesAdministered'] as int,
          dosesWasted: (row['dosesWasted'] as int?) ?? 0,
        );
      case 'mortality':
        return MortalityProduction(
          id: id,
          date: date,
          dead: row['dead'] as int,
          missing: row['missing'] as int,
          cause: row['cause'] as String?,
        );
      default:
        throw Exception('Unknown production type: ${row['type']}');
    }
  }

  Future<List<Production>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query('production', orderBy: 'date DESC');
    return rows.map(_fromRow).toList();
  }

  Future<void> insert(Production production) async {
    final db = await _dbHelper.database;
    await db.insert('production', _toRow(production));
  }

  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete('production', where: 'id = ?', whereArgs: [id]);
  }
}
