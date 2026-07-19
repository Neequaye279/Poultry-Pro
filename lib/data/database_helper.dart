import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _db;
  static Future<Database>? _opening;

  Future<Database> get database async {
    if (_db != null) return _db!;
    if (_opening != null) return _opening!;

    _opening = _initDb();
    _db = await _opening;
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'poultry_pro.db');

    return openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE flocks (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        status TEXT NOT NULL,
        initialBirdCount INTEGER NOT NULL,
        currentBirdCount INTEGER NOT NULL,
        ageInWeeks INTEGER,
        imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE production (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        collected INTEGER,
        broken INTEGER,
        amountAdded REAL,
        amountRemaining REAL,
        vaccineName TEXT,
        dosesAdministered INTEGER,
        dosesWasted INTEGER,
        dead INTEGER,
        missing INTEGER,
        cause TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        name TEXT NOT NULL,
        farm TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        notificationsEnabled INTEGER NOT NULL,
        biometricsEnabled INTEGER NOT NULL,
        appearanceMode TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS transactions (
          id TEXT PRIMARY KEY,
          type TEXT NOT NULL,
          category TEXT NOT NULL,
          amount REAL NOT NULL,
          date TEXT NOT NULL,
          note TEXT
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS settings (
          id INTEGER PRIMARY KEY CHECK (id = 1),
          name TEXT NOT NULL,
          farm TEXT NOT NULL,
          phone TEXT NOT NULL,
          email TEXT NOT NULL,
          notificationsEnabled INTEGER NOT NULL,
          biometricsEnabled INTEGER NOT NULL,
          appearanceMode TEXT NOT NULL
        )
      ''');
    }
  }
}
