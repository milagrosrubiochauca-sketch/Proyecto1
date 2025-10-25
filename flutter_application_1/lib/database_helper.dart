import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finanzas_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla para metas de ahorro
    await db.execute('''
      CREATE TABLE metas_ahorro(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        monto_objetivo REAL NOT NULL,
        monto_actual REAL NOT NULL,
        fecha_objetivo TEXT NOT NULL,
        color TEXT NOT NULL,
        icono TEXT NOT NULL,
        creado_en TEXT NOT NULL
      )
    ''');

    // Tabla para presupuestos
    await db.execute('''
      CREATE TABLE presupuestos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoria TEXT NOT NULL,
        limite_gasto REAL NOT NULL,
        gastado REAL NOT NULL,
        meta_ahorro REAL NOT NULL,
        color TEXT NOT NULL,
        creado_en TEXT NOT NULL
      )
    ''');

    // Tabla para transacciones/gastos
    await db.execute('''
      CREATE TABLE transacciones(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monto REAL NOT NULL,
        categoria TEXT NOT NULL,
        descripcion TEXT,
        tipo TEXT NOT NULL, -- 'ingreso' o 'gasto'
        fecha TEXT NOT NULL,
        creado_en TEXT NOT NULL
      )
    ''');

    // Insertar datos de ejemplo
    await _insertarDatosEjemplo(db);
  }

  Future<void> _insertarDatosEjemplo(Database db) async {
    final now = DateTime.now().toIso8601String();

    // Metas de ejemplo
    await db.insert('metas_ahorro', {
      'nombre': 'Comprar Laptop',
      'monto_objetivo': 2500.0,
      'monto_actual': 1200.0,
      'fecha_objetivo': DateTime(2024, 12, 31).toIso8601String(),
      'color': '4280391411', // Esto es correcto para Colors.blue
      'icono': 'laptop',
      'creado_en': now,
    });

    await db.insert('metas_ahorro', {
      'nombre': 'Viaje a la Playa',
      'monto_objetivo': 1500.0,
      'monto_actual': 800.0,
      'fecha_objetivo': DateTime(2024, 10, 15).toIso8601String(),
      'color': '4283215696', // Esto es correcto para Colors.green
      'icono': 'beach_access',
      'creado_en': now,
    });

    // Presupuestos de ejemplo
    await db.insert('presupuestos', {
      'categoria': 'Comida',
      'limite_gasto': 1500.0,
      'gastado': 1200.0,
      'meta_ahorro': 200.0,
      'color': '4280391411', // Colors.blue
      'creado_en': now,
    });

    await db.insert('presupuestos', {
      'categoria': 'Transporte',
      'limite_gasto': 1000.0,
      'gastado': 800.0,
      'meta_ahorro': 150.0,
      'color': '4283215696', // Colors.green
      'creado_en': now,
    });

    // Transacciones de ejemplo
    await db.insert('transacciones', {
      'monto': 1200.0,
      'categoria': 'Comida',
      'descripcion': 'Gastos mensuales en comida',
      'tipo': 'gasto',
      'fecha': DateTime.now().toIso8601String(),
      'creado_en': now,
    });
  }

  // Métodos para Metas de Ahorro
  Future<int> insertMeta(Map<String, dynamic> meta) async {
    final db = await database;
    return await db.insert('metas_ahorro', meta);
  }

  Future<List<Map<String, dynamic>>> getMetas() async {
    final db = await database;
    return await db.query('metas_ahorro', orderBy: 'creado_en DESC');
  }

  Future<int> updateMeta(int id, Map<String, dynamic> meta) async {
    final db = await database;
    return await db.update(
      'metas_ahorro',
      meta,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMeta(int id) async {
    final db = await database;
    return await db.delete(
      'metas_ahorro',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para Presupuestos
  Future<int> insertPresupuesto(Map<String, dynamic> presupuesto) async {
    final db = await database;
    return await db.insert('presupuestos', presupuesto);
  }

  Future<List<Map<String, dynamic>>> getPresupuestos() async {
    final db = await database;
    return await db.query('presupuestos', orderBy: 'creado_en DESC');
  }

  Future<int> updatePresupuesto(
      int id, Map<String, dynamic> presupuesto) async {
    final db = await database;
    return await db.update(
      'presupuestos',
      presupuesto,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePresupuesto(int id) async {
    final db = await database;
    return await db.delete(
      'presupuestos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para Transacciones
  Future<int> insertTransaccion(Map<String, dynamic> transaccion) async {
    final db = await database;
    return await db.insert('transacciones', transaccion);
  }

  Future<List<Map<String, dynamic>>> getTransacciones() async {
    final db = await database;
    return await db.query('transacciones', orderBy: 'fecha DESC');
  }

  Future<List<Map<String, dynamic>>> getTransaccionesPorCategoria(
      String categoria) async {
    final db = await database;
    return await db.query(
      'transacciones',
      where: 'categoria = ?',
      whereArgs: [categoria],
      orderBy: 'fecha DESC',
    );
  }

  Future<int> deleteTransaccion(int id) async {
    final db = await database;
    return await db.delete(
      'transacciones',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos utilitarios
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
