import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'app_database.db';
  static const _databaseVersion = 1;
  static const _tableName = 'auth';
  static const _columnId = 'id';
  static const _columnToken = 'token';
  static const _columnUserId = 'user_id';

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

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create the auth table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnToken TEXT NOT NULL,
        $_columnUserId INTEGER
      )
    ''');
  }

  // Save the token to the database
  Future<void> saveToken(String token) async {
    final db = await database;
    await db.delete(_tableName); // Clear existing tokens
    await db.insert(_tableName, {_columnToken: token});
  }

  // Retrieve the token from the database
  Future<String?> getToken() async {
    final db = await database;
    final result = await db.query(_tableName, limit: 1);

    if (result.isNotEmpty) {
      return result.first[_columnToken] as String?;
    }
    return null;
  }

  // Save the user ID to the database
  Future<void> saveUserId(int userId) async {
    final db = await database;
    await db.delete(_tableName); // Clear existing user IDs
    await db.insert(_tableName, {_columnUserId: userId});
  }

  // Retrieve the user ID from the database
  Future<int?> getUserId() async {
    final db = await database;
    final result = await db.query(_tableName, limit: 1);

    if (result.isNotEmpty) {
      return result.first[_columnUserId] as int?;
    }
    return null;
  }

  // Clear the token and user ID from the database (e.g., on logout)
  Future<void> clearToken() async {
    final db = await database;
    await db.delete(_tableName);
  }

  Future<void> clearUserId() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
