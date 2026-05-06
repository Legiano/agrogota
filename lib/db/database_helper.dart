import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/solo.dart';
import '../models/cultura.dart';
import '../models/entrada_climatica.dart';
import '../models/resultado.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'irriga_facil.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE cultura ADD COLUMN gotejadores INTEGER DEFAULT 1');
        }
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE solo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        silte REAL, argila REAL, cc REAL, pmp REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE cultura (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT, estagio TEXT, kc REAL,
        espacamento REAL, vazao REAL,
        gotejadores INTEGER DEFAULT 1
      )
    ''');
    await db.execute('''
      CREATE TABLE entrada_climatica (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT, tMax REAL, tMin REAL,
        urMax REAL, urMin REAL,
        radiacao REAL, radiacaoEstimada INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE resultado (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT, eto REAL, etc REAL,
        lamina REAL, volume REAL, tempoMin REAL
      )
    ''');
  }

  // Solo
  Future<int> salvarSolo(Solo solo) async {
    final db = await database;
    return db.insert('solo', solo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Solo?> getSolo() async {
    final db = await database;
    final maps = await db.query('solo', limit: 1, orderBy: 'id DESC');
    if (maps.isEmpty) return null;
    return Solo.fromMap(maps.first);
  }

  // Cultura
  Future<int> salvarCultura(Cultura cultura) async {
    final db = await database;
    return db.insert('cultura', cultura.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Cultura?> getCultura() async {
    final db = await database;
    final maps = await db.query('cultura', limit: 1, orderBy: 'id DESC');
    if (maps.isEmpty) return null;
    return Cultura.fromMap(maps.first);
  }

  // Entrada climática
  Future<int> salvarEntrada(EntradaClimatica entrada) async {
    final db = await database;
    return db.insert('entrada_climatica', entrada.toMap());
  }

  // Resultado
  Future<int> salvarResultado(Resultado resultado) async {
    final db = await database;
    return db.insert('resultado', resultado.toMap());
  }

  Future<List<Resultado>> getHistorico() async {
    final db = await database;
    final maps = await db.query('resultado',
        orderBy: 'data DESC', limit: 30);
    return maps.map((m) => Resultado.fromMap(m)).toList();
  }

  // Excluir resultado do histórico
  Future<void> excluirResultado(int id) async {
    final db = await database;
    await db.delete('resultado', where: 'id = ?', whereArgs: [id]);
  }

  // Limpar configurações (solo e cultura)
  Future<void> limparConfiguracoes() async {
    final db = await database;
    await db.delete('solo');
    await db.delete('cultura');
  }
}