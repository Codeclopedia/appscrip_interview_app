import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'app_database.db';
  static const _databaseVersion = 1;
  static const _tableName = 'tokens';
  static const _columnId = 'id';
  static const _columnToken = 'token';

  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnToken TEXT NOT NULL
      )
    ''');
  }

  Future<void> saveToken(String token) async {
    final db = await database;
    await db.delete(_tableName); // Clear existing tokens
    await db.insert(_tableName, {_columnToken: token});
  }

  Future<String?> getToken() async {
    final db = await database;
    final result = await db.query(_tableName, limit: 1);

    if (result.isNotEmpty) {
      return result.first[_columnToken] as String?;
    }
    return null;
  }

  Future<void> clearToken() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
