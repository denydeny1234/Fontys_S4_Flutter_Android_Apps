// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart'; // Ensure you have this import for path_provider
// import 'recipe.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database; // Make _database nullable

//   DatabaseHelper._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('recipes.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
// CREATE TABLE recipes (
//   id INTEGER PRIMARY KEY AUTOINCREMENT,
//   title TEXT NOT NULL,
//   imagePath TEXT NOT NULL
// )
// ''');
//   }

//   Future<Recipe> create(Recipe recipe) async {
//     final db = await instance.database;
//     final id = await db.insert('recipes', recipe.toMap());
//     print('Recipe inserted with id: $id');
//     return recipe.copy(id: id);
//   }

//   Future<Recipe?> getRecipeByTitle(String title) async {
//     final db = await instance.database;
//     final result = await db.query(
//       'recipes',
//       where: 'title = ?',
//       whereArgs: [title],
//     );
//     if (result.isNotEmpty) {
//       return Recipe.fromMap(result.first);
//     }
//     return null; // Return null if the recipe is not found.
//   }

//   Future<List<Recipe>> readAllRecipes() async {
//     final db = await instance.database;

//     final orderBy = 'title ASC';
//     final result = await db.query('recipes', orderBy: orderBy);

//     return result.map((json) => Recipe.fromMap(json)).toList();
//   }

//   Future close() async {
//     final db = await instance.database;

//     db.close();
//   }
// }

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'recipe.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE recipes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    imagePath TEXT NOT NULL,
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL
  )
  ''');
  }

  Future<Recipe> create(Recipe recipe) async {
    final db = await database;
    final id = await db.insert('recipes', recipe.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return recipe.copy(id: id); // Ensure ID is returned and used correctly.
  }

  Future<List<Recipe>> readAllRecipes() async {
    final db = await database;
    final result = await db.query('recipes', orderBy: 'title ASC');
    return result.map((json) => Recipe.fromMap(json)).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
