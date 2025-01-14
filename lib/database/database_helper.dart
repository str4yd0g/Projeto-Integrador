import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_integrador/models/usuario.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    databaseFactory = databaseFactoryFfi;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    // Caminho do banco
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/projeto_integrador.db';

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        telefone TEXT,
        email TEXT
      )
    ''');
  }

  Future<int> insertUsuario(Usuario usuario) async {
    final db = await instance.database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<List<Usuario>> fetchUsuarios() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('usuarios');

    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i]);
    });
  }

  Future<int> updateUsuario(Usuario usuario) async {
    final db = await instance.database;
    return await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> deleteUsuario(int id) async {
    final db = await instance.database;
    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Usuario>> getUsuarios() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('usuarios');

    if (maps.isNotEmpty) {
      return maps.map((map) => Usuario.fromMap(map)).toList();
    } else {
      return [];
    }
  }
}
