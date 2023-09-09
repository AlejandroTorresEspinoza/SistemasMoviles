import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/models/user.dart';

class DatabaseHelper {
  static final _databaseName = "users.db";
  static final _databaseVersion = 1;

  static final table = 'users';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnInstitutionalCode = 'institutionalCode';
  static final columnPassword = 'password';
  static final columnActive = 'activo';

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database init
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnInstitutionalCode TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnActive INTEGER DEFAULT 1
          )
          ''');
  }

  // Insert user
  Future<int> insert(User user) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'name': user.name,
      'email': user.email,
      'institutionalCode': user.institutionalCode,
      'password': user.password,  // ¡Considera encriptar esto!
    });
  }

  Future<bool> emailExists(String email) async {
    Database db = await instance.database;
    var result = await db.query(table, where: '$columnEmail = ?', whereArgs: [email]);
    return result.isNotEmpty;
  }

  Future<bool> institutionalCodeExists(String code) async {
    Database db = await instance.database;
    var result = await db.query(table, where: '$columnInstitutionalCode = ?', whereArgs: [code]);
    return result.isNotEmpty;
  }

  Future<User?> getUser(String email, String password) async {
    Database db = await instance.database;
    var result = await db.query(table, where: '$columnEmail = ? AND $columnPassword = ? AND $columnActive = 1', whereArgs: [email, password]);
    if (result.isNotEmpty) {
      return User(
        id: result.first[columnId] as int?,
        name: result.first[columnName] as String,
        email: result.first[columnEmail] as String,
        institutionalCode: result.first[columnInstitutionalCode] as String,
        password: result.first[columnPassword] as String,
        active: result.first[columnActive] as int,
      );
    }
    return null;
  }


}
