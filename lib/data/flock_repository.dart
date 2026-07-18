import 'package:poultry_pro/data/database_helper.dart';
import 'package:poultry_pro/model/flock.dart';
import 'package:poultry_pro/model/flock_category.dart';
import 'package:poultry_pro/model/status_category.dart';

class FlockRepository {
  final _dbHelper = DatabaseHelper.instance;

  Map<String, dynamic> _toRow(Flock f) {
    return {
      'id': f.id,
      'name': f.name,
      'category': f.category.name,
      'status': f.status.name,
      'initialBirdCount': f.initialBirdCount,
      'currentBirdCount': f.currentBirdCount,
      'ageInWeeks': f.ageInWeeks,
      'imagePath': f.imagePath,
    };
  }

  Flock _fromRow(Map<String, dynamic> row) {
    return Flock(
      id: row['id'] as String,
      name: row['name'] as String,
      category: FlockCategory.values.byName(row['category'] as String),
      status: FlockStatus.values.byName(row['status'] as String),
      initialBirdCount: row['initialBirdCount'] as int,
      currentBirdCount: row['currentBirdCount'] as int,
      ageInWeeks: row['ageInWeeks'] as int?,
      imagePath: row['imagePath'] as String?,
    );
  }

  Future<List<Flock>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query('flocks');
    return rows.map(_fromRow).toList();
  }

  Future<void> insert(Flock flock) async {
    final db = await _dbHelper.database;
    await db.insert('flocks', _toRow(flock));
  }

  Future<void> update(Flock flock) async {
    final db = await _dbHelper.database;
    await db.update(
      'flocks',
      _toRow(flock),
      where: 'id = ?',
      whereArgs: [flock.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete('flocks', where: 'id = ?', whereArgs: [id]);
  }
}
