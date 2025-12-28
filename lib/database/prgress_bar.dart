import 'dart:io';
import 'package:jab_zindagi_shuru_hogi_inzaar/models/progress_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ProgressDB {
  ProgressDB._();
  static final ProgressDB instance = ProgressDB._();
  Database? _db;

  Future<Database> getDB() async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDB();
      return _db!;
    }
  }

  Future<Database> initDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = join(appDir.path, "progressDB.db");

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE IF NOT EXISTS progress (
  chapterID INTEGER PRIMARY KEY,
  offset REAL NOT NULL,
  progress REAL NOT NULL,
  lastReadAt INTEGER NOT NULL  
)
''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE progress ADD COLUMN lastReadAt INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );

    return db;
  }

  Future<bool> saveProgress(
    int chapterID,
    double offset,
    double progress,
  ) async {
    try {
      final db = await getDB();

      await db.insert(
        'progress',
        {
          'chapterID': chapterID,
          'offset': offset,
          'progress': progress,
          'lastReadAt': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace, // update bhi ho sake
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ProgressModel> loadChapterProgress(int chapterID) async {
    final db = await getDB();

    final List<Map<String, dynamic>> results = await db.query(
      'progress',
      columns: [
        'chapterID',
        'progress',
        'offset',
        'lastReadAt',
      ], // ← lastReadAt add kiya
      where: 'chapterID = ?',
      whereArgs: [chapterID],
    );

    if (results.isEmpty) {
      // Pehli baar ya chapter nahi padha → default values
      return ProgressModel(
        chapterID: chapterID,
        progress: 0.0,
        offset: 0.0,
        lastReadAt:
            DateTime.now(), // current time daal do (optional, lekin safe)
      );
    }

    // Saved entry mili → fromMap se model banao
    return ProgressModel.fromMap(results.first);
  }

  Future<List<ProgressModel>> loadAllProgress() async {
    final db = await getDB();
    final progressList = await db.query('progress');

    // Sirf real saved entries return karo
    return progressList.map((row) => ProgressModel.fromMap(row)).toList();
  }
}
