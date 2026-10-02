import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class DatabaseHelper {
  static const String _dbName = 'users.db';
  static const int _dbVersion = 1;
  static const String tableUsers = 'Users';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colPassword = '_password';
  static const String colIsActive = 'isActive';

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
      CREATE TABLE $tableUsers (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT UNIQUE,
        $colPassword TEXT,
        $colIsActive INTEGER
      )
    ''');

    const defaultPassword = '123';

    await db.insert(tableUsers, {
      colName: 'Alex',
      colPassword: defaultPassword,
      colIsActive: 1,
    });
    await db.insert(tableUsers, {
      colName: 'Andy',
      colPassword: defaultPassword,
      colIsActive: 0,
    });
    await db.insert(tableUsers, {
      colName: 'Ben',
      colPassword: defaultPassword,
      colIsActive: 0,
    });
    await db.insert(tableUsers, {
      colName: 'Nick',
      colPassword: defaultPassword,
      colIsActive: 0,
    });
    await db.insert(tableUsers, {
      colName: 'Trump',
      colPassword: defaultPassword,
      colIsActive: 1,
    });
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      orderBy: '$colId ASC',
    );
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<User?> authenticate(String name, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: '$colName = ? AND $colPassword = ?',
      whereArgs: [name, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: '$colName = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(
      tableUsers,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<int> updateActiveStatus(int id, int isActive) async {
    final db = await database;
    return await db.update(
      tableUsers,
      {colIsActive: isActive},
      where: '$colId = ?',
      whereArgs: [id],
    );
  }
}
