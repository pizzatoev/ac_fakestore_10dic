import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.model.dart';

class ProductLocalService {
  static final ProductLocalService _instance = ProductLocalService._internal();
  factory ProductLocalService() => _instance;
  ProductLocalService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'products.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        image TEXT NOT NULL,
        isLocal INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  // Insertar producto local
  Future<int> insertProduct(Product product) async {
    final db = await database;
    // Para productos locales, usamos un ID negativo único
    // Generamos un ID negativo basado en timestamp para evitar conflictos
    final localId = product.id < 0 
        ? product.id 
        : -(DateTime.now().millisecondsSinceEpoch % 2147483647);
    
    final productMap = {
      'id': localId,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': product.image,
      'isLocal': 1,
    };

    await db.insert('products', productMap, conflictAlgorithm: ConflictAlgorithm.replace);
    return localId;
  }

  // Obtener todos los productos locales
  Future<List<Product>> getAllLocalProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products', where: 'isLocal = ?', whereArgs: [1]);
    return List.generate(maps.length, (i) {
      return Product(
        maps[i]['id'] as int,
        maps[i]['title'] as String,
        maps[i]['price'] as double,
        maps[i]['description'] as String,
        maps[i]['category'] as String,
        maps[i]['image'] as String,
      );
    });
  }

  // Obtener producto por ID
  Future<Product?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ? AND isLocal = ?',
      whereArgs: [id, 1],
    );

    if (maps.isEmpty) return null;

    return Product(
      maps[0]['id'] as int,
      maps[0]['title'] as String,
      maps[0]['price'] as double,
      maps[0]['description'] as String,
      maps[0]['category'] as String,
      maps[0]['image'] as String,
    );
  }

  // Actualizar producto local
  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      {
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'image': product.image,
      },
      where: 'id = ? AND isLocal = ?',
      whereArgs: [product.id, 1],
    );
  }

  // Eliminar producto local
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ? AND isLocal = ?',
      whereArgs: [id, 1],
    );
  }

  // Obtener productos por categoría
  Future<List<Product>> getProductsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'category = ? AND isLocal = ?',
      whereArgs: [category, 1],
    );
    return List.generate(maps.length, (i) {
      return Product(
        maps[i]['id'] as int,
        maps[i]['title'] as String,
        maps[i]['price'] as double,
        maps[i]['description'] as String,
        maps[i]['category'] as String,
        maps[i]['image'] as String,
      );
    });
  }

  // Cerrar base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

