import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProfessor {
  static final _databaseName = "professors.db";
  static final _databaseVersion = 1;

  static final table = 'professors';

  static final columnId = 'id';
  static final columnPaterno = 'paterno';
  static final columnMaterno = 'materno';
  static final columnNombres = 'nombres';
  static final columnCorreo = 'correo';

  // Singleton
  DatabaseProfessor._privateConstructor();
  static final DatabaseProfessor instance = DatabaseProfessor._privateConstructor();

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
            $columnPaterno TEXT NOT NULL,
            $columnMaterno TEXT NOT NULL,
            $columnNombres TEXT NOT NULL,
            $columnCorreo TEXT NOT NULL
          )
          ''');

    var initialProfessors = [
      {'paterno': 'Huayna', 'materno': 'Dueñas', 'nombres': 'Ana Maria', 'correo': 'ahuaynad@unmsm.edu.pe'},
      {'paterno': 'Lopez', 'materno': 'Villanueva', 'nombres': 'Pablo Edwin', 'correo': 'plopezv@unmsm.edu.pe'},
      {'paterno': 'Espinoza', 'materno': 'Robles', 'nombres': 'Armando David', 'correo': 'aespinozar@unmsm.edu.pe'},
      {'paterno': 'Moreno', 'materno': 'Sucre', 'nombres': 'Fanny', 'correo': 'fmorenosu@unmsm.edu.pe'},
      {'paterno': 'Chavez', 'materno': 'Soto', 'nombres': 'Jorge Luis', 'correo': 'jchavezs@unmsm.edu.pe'},
      {'paterno': 'Pariona', 'materno': 'Quispe', 'nombres': 'Jaime Ruben', 'correo': 'jparionaq@unmsm.edu.pe'},
      {'paterno': 'Moquillaza', 'materno': 'Henriquez', 'nombres': 'Santiago Domingo', 'correo': 'smoquillazah@unmsm.edu.pe'},
      {'paterno': 'Maguiña', 'materno': 'Perez', 'nombres': 'Rolando Alberto', 'correo': 'rmaguinap@unmsm.edu.pe'},
      {'paterno': 'Delgadillo', 'materno': 'Avila de Mauricio', 'nombres': 'Rosa Sumactika', 'correo': 'rdelgadilloa@unmsm.edu.pe'},
      {'paterno': 'Puelles', 'materno': 'Bulnes', 'nombres': 'Maria Elizabeth', 'correo': 'mpuellesb@unmsm.edu.pe'},
      {'paterno': 'Valle', 'materno': 'Santos', 'nombres': 'John', 'correo': 'jvalles@unmsm.edu.pe'},
      {'paterno': 'Sanchez', 'materno': 'De Sanchez', 'nombres': 'Lleyni Reategui', 'correo': 'lreateguis@unmsm.edu.pe'},
      {'paterno': 'Roman', 'materno': 'Concha', 'nombres': 'Norberto Ulises', 'correo': 'nromanc@unmsm.edu.pe'},
      {'paterno': 'Herrera', 'materno': 'Quispe', 'nombres': 'Jose Alfredo', 'correo': 'jherreraqu@unmsm.edu.pe'},
      {'paterno': 'Trujillo', 'materno': 'Trejo', 'nombres': 'John Ledgard', 'correo': 'jtrujillot@unmsm.edu.pe'},
      {'paterno': 'Luza', 'materno': 'Montero', 'nombres': 'César', 'correo': 'cluzam@unmsm.edu.pe'},
      {'paterno': 'Escobedo','materno': 'Bailón','nombres': 'Frank Edmundo', 'correo': 'fescobedob@unmsm.edu.pe'},
      {'paterno': 'Pro','materno': 'Concepcion','nombres': 'Luzmila Elisa', 'correo': 'lproc@unmsm.edu.pe'},
      {'paterno': 'Ruiz','materno':'Rivera','nombres':'Maria Elena','correo': 'mruizr@unmsm.edu.pe'},
      {'paterno': 'Salinas','materno':'Azaña','nombres':'Gilberto Anibal','correo':'gsalinasa@unmsm.edu.pe'},
      {'paterno': 'Guerra','materno':'Grados','nombres': 'Luis Angel', 'correo':'lguerrag1@unmsm.edu.pe'}
    ];

    for (var professor in initialProfessors) {
      await db.insert(table, professor);
    }
  }

  Future<List<Map<String, dynamic>>> getAllProfessors() async {
    Database db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> searchProfessors(String query) async {
    Database db = await database;

    return await db.query(
      table,
      where: '$columnNombres LIKE ? OR $columnPaterno LIKE ? OR $columnMaterno LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
  }
// Aquí pondré funciones para insertar, actualizar, borrar o consultar profesores con el usuario admin
}
