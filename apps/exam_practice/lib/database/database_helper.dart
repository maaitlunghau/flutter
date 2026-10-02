import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';

class DatabaseHelper {
  static const String _dbName = 'ContactDB.db';
  static const int _dbVersion = 1;
  static const String tableContacts = 'Contacts';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colPhone = 'phone';
  static const String colEmail = 'email';
  static const String colIsFavorite = 'isFavorite';

  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableContacts (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT,
        $colPhone TEXT,
        $colEmail TEXT,
        $colIsFavorite INTEGER
      )
    ''');

    // Thêm dữ liệu mẫu ban đầu như trong Figure 1
    await db.insert(tableContacts, {
      colName: 'Alex',
      colPhone: '0123456789',
      colEmail: 'alex@example.com',
      colIsFavorite: 1,
    });
    await db.insert(tableContacts, {
      colName: 'Paul',
      colPhone: '0987654321',
      colEmail: 'paul@example.com',
      colIsFavorite: 0,
    });
  }

  Future<List<Contact>> getAllContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableContacts);
    return maps.map((map) => Contact.fromMap(map)).toList();
  }

  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert(
      tableContacts,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateFavorite(int id, int isFavorite) async {
    final db = await database;
    return await db.update(
      tableContacts,
      {colIsFavorite: isFavorite},
      where: '$colId = ?',
      whereArgs: [id],
    );
  }
}
