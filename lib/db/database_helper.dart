import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/solo.dart';
import '../models/cultura.dart';
import '../models/entrada_climatica.dart';
import '../models/resultado.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  // ==================== WEB ====================
  // Na web usa SharedPreferences em vez de SQLite

  Future<void> salvarSoloWeb(Solo solo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('solo', jsonEncode(solo.toMap()));
  }

  Future<Solo?> getSoloWeb() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('solo');
    if (json == null) return null;
    return Solo.fromMap(jsonDecode(json));
  }

  Future<void> salvarCulturaWeb(Cultura cultura) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cultura', jsonEncode(cultura.toMap()));
  }

  Future<Cultura?> getCulturaWeb() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('cultura');
    if (json == null) return null;
    return Cultura.fromMap(jsonDecode(json));
  }

  Future<void> salvarResultadoWeb(Resultado resultado) async {
    // CORREÇÃO: garante que todo resultado salvo na web tenha um id único.
    // Antes, o id ficava null e a exclusão nunca era executada
    // (historico_screen.dart só chama excluirResultado quando r.id != null).
    resultado.id ??= resultado.data.millisecondsSinceEpoch;

    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('historico') ?? [];
    lista.insert(0, jsonEncode(resultado.toMap()));
    if (lista.length > 30) lista.removeLast();
    await prefs.setStringList('historico', lista);
  }

  Future<List<Resultado>> getHistoricoWeb() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('historico') ?? [];
    return lista.map((e) => Resultado.fromMap(jsonDecode(e))).toList();
  }

  Future<void> excluirResultadoWeb(int id) async {
    // CORREÇÃO: antes recebia um índice de lista (int index) e usava
    // lista.removeAt(index) — mas quem chamava passava o id do registro
    // (r.id!), não a posição dele na lista. Agora filtra pelo id de verdade.
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList('historico') ?? [];
    lista.removeWhere((item) {
      final r = Resultado.fromMap(jsonDecode(item));
      return r.id == id;
    });
    await prefs.setStringList('historico', lista);
  }

  Future<void> limparConfiguracoesWeb() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('solo');
    await prefs.remove('cultura');
  }

  // ==================== ANDROID ====================

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

  // ==================== MÉTODOS UNIFICADOS ====================

  Future<int> salvarSolo(Solo solo) async {
    if (kIsWeb) {
      await salvarSoloWeb(solo);
      return 1;
    }
    final db = await database;
    return db.insert('solo', solo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Solo?> getSolo() async {
    if (kIsWeb) return getSoloWeb();
    final db = await database;
    final maps = await db.query('solo', limit: 1, orderBy: 'id DESC');
    if (maps.isEmpty) return null;
    return Solo.fromMap(maps.first);
  }

  Future<int> salvarCultura(Cultura cultura) async {
    if (kIsWeb) {
      await salvarCulturaWeb(cultura);
      return 1;
    }
    final db = await database;
    return db.insert('cultura', cultura.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Cultura?> getCultura() async {
    if (kIsWeb) return getCulturaWeb();
    final db = await database;
    final maps = await db.query('cultura', limit: 1, orderBy: 'id DESC');
    if (maps.isEmpty) return null;
    return Cultura.fromMap(maps.first);
  }

  Future<int> salvarEntrada(EntradaClimatica entrada) async {
    if (kIsWeb) return 1;
    final db = await database;
    return db.insert('entrada_climatica', entrada.toMap());
  }

  Future<int> salvarResultado(Resultado resultado) async {
    if (kIsWeb) {
      await salvarResultadoWeb(resultado);
      return 1;
    }
    final db = await database;
    return db.insert('resultado', resultado.toMap());
  }

  Future<List<Resultado>> getHistorico() async {
    if (kIsWeb) return getHistoricoWeb();
    final db = await database;
    final maps = await db.query('resultado',
        orderBy: 'data DESC', limit: 30);
    return maps.map((m) => Resultado.fromMap(m)).toList();
  }

  Future<void> excluirResultado(int id) async {
    if (kIsWeb) {
      await excluirResultadoWeb(id);
      return;
    }
    final db = await database;
    await db.delete('resultado', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> limparConfiguracoes() async {
    if (kIsWeb) {
      await limparConfiguracoesWeb();
      return;
    }
    final db = await database;
    await db.delete('solo');
    await db.delete('cultura');
  }
}