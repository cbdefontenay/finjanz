import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finjanz.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, amount REAL, date TEXT, note TEXT, isRecurring INTEGER DEFAULT 0)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE expenses ADD COLUMN isRecurring INTEGER DEFAULT 0');
        }
      },
    );
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<List<String>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT category FROM expenses',
    );
    return List.generate(maps.length, (i) => maps[i]['category'] as String);
  }

  Future<void> renameCategory(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'expenses',
      {'category': newName},
      where: 'category = ?',
      whereArgs: [oldName],
    );
  }

  Future<void> deleteCategory(String name) async {
    final db = await database;
    await db.delete('expenses', where: 'category = ?', whereArgs: [name]);
  }

  Future<void> insertExpensesBatch(List<Expense> expenses) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var expense in expenses) {
        await txn.insert('expenses', expense.toMap());
      }
    });
  }
}
