import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/mood_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'moods.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE moods(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mood TEXT,
            reason TEXT,
            sleepQuality TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertMood(MoodEntry entry) async {
    final db = await database;
    await db.insert('moods', entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MoodEntry>> getAllMoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('moods');
    return List.generate(maps.length, (i) => MoodEntry.fromMap(maps[i]));
  }
}
