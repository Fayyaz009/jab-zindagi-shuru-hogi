import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ThemeDB {
  ThemeDB._();
  static final ThemeDB instance = ThemeDB._();

  Database? _db;

  Future<Database> getDB() async {
    _db ??= await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final appDir = await getApplicationDocumentsDirectory();
    final path = join(appDir.path, "themeDB.db");

    return await openDatabase(
      path,
      version: 2, // Updated version for sepia unlock
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS themeDB (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            themeType TEXT NOT NULL
          );
        ''');

        // New table for sepia unlock status
        await db.execute('''
          CREATE TABLE IF NOT EXISTS sepiaUnlock (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            isUnlocked INTEGER NOT NULL DEFAULT 0
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS sepiaUnlock (
              id INTEGER PRIMARY KEY CHECK (id = 1),
              isUnlocked INTEGER NOT NULL DEFAULT 0
            );
          ''');
        }
      },
      onOpen: (db) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS sepiaUnlock (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            isUnlocked INTEGER NOT NULL DEFAULT 0
          );
        ''');
      },
    );
  }

  /// SAVE (always overwrite)
  Future<void> saveTheme(String theme) async {
    final db = await getDB();

    await db.insert('themeDB', {
      'id': 1,
      'themeType': theme,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// LOAD (single value)
  Future<String?> loadTheme() async {
    final db = await getDB();

    final result = await db.query(
      'themeDB',
      columns: ['themeType'],
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    return result.isNotEmpty ? result.first['themeType'] as String : null;
  }

  /// SAVE sepia unlock status
  Future<void> saveSepiaUnlock(bool isUnlocked) async {
    final db = await getDB();

    await db.insert('sepiaUnlock', {
      'id': 1,
      'isUnlocked': isUnlocked ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// LOAD sepia unlock status
  Future<bool> loadSepiaUnlock() async {
    final db = await getDB();

    final result = await db.query(
      'sepiaUnlock',
      columns: ['isUnlocked'],
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['isUnlocked'] == 1;
    }
    return false; // Default: sepia is locked
  }
}
