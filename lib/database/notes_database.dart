import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/models/note_model.dart';

class NotesDB {
  static final NotesDB instance = NotesDB._init();
  static Database? _database;

  NotesDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const stringType = 'TEXT NOT NULL';
    const nullableStringType = 'TEXT';

    await db.execute('''
    CREATE TABLE notes (
      id $idType,
      chapterID $intType,
      chapterTitle $stringType,
      text $textType,
      note $nullableStringType,
      colorValue $intType,
      startIndex $intType,
      endIndex $intType,
      createdAt $stringType
    )
    ''');
  }

  Future<int> createNote(NoteModel note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<NoteModel>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = 'createdAt DESC';
    final result = await db.query('notes', orderBy: orderBy);

    return result.map((json) => NoteModel.fromMap(json)).toList();
  }

  Future<List<NoteModel>> readNotesByChapter(int chapterID) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'chapterID = ?',
      whereArgs: [chapterID],
    );

    return result.map((json) => NoteModel.fromMap(json)).toList();
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
