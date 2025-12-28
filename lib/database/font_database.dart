import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FontDB {
  FontDB._();
  static final FontDB instance = FontDB._();
  Database? _db;

  Future<Database> getDB() async {
    if (_db != null) {
      return _db!;
    } else {
      final db = await initDB();
      return db;
    }
  }

  Future<Database> initDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    final path = join(appDir.path, "fontDB.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''

CREATE TABLE IF NOT EXISTS fontDB (
id INTEGER PRIMARY KEY CHECK(id=1),
fontSize REAL NOT NULL
)


''');
      },
    );
  }

  Future<bool> saveFonts(double fontSize) async {
    final db = await getDB();
    int rowsEffected = await db.insert("fontDB", {
      'id': 1,
      'fontSize': fontSize,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    return rowsEffected > 0;
  }

  Future<double> loadFonts() async {
    try {
      Database db = await getDB();
      final results = await db.query("fontDB", columns: ['fontSize']);
      if (results.isNotEmpty) {
        return results.first['fontSize'] as double;
      } else {
        return 1.0;
      }
    } catch (e) {
      return 1.0;
    }
  }
}
