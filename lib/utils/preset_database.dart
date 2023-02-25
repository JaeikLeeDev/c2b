import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PresetDatabase {
  final String tableName;
  final String _dbName = 'chord_presets.db';
  late final String _databasesPath;
  late final Database _chordPresetDb;

  PresetDatabase({required this.tableName});

  Future<void> init() async {
    await getDbPath();
    await openDb();
  }

  Future<void> getDbPath() async {
    var path = await getDatabasesPath();
    _databasesPath = join(path, _dbName);
    print(_databasesPath);
  }

  Future<void> openDb() async {
    _chordPresetDb = await openDatabase(
      _databasesPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, name TEXT, chords TEXT)');
      },
    );
  }

  Future<void> closeDb() async {
    await _chordPresetDb.close();
  }

  Future<void> cleanUpDb() async {
    await closeDb();
    await deleteDatabase(_databasesPath);
    await openDb();
  }

  Future<void> savePreset(String presetName, List<String> chords) async {
    var count = Sqflite.firstIntValue(
        await _chordPresetDb.rawQuery('SELECT COUNT(*) FROM $tableName'));
    count ??= 0;

    await _chordPresetDb.transaction((txn) async {
      var id = await txn.rawInsert(
          'INSERT INTO $tableName(id, name, chords) VALUES(?, ?, ?)',
          [count! + 1, presetName, chords.join(',')]);
      print('inserted: $id');
    });
  }

  Future<List<Map<String, Object?>>> query(String q) async {
    return await _chordPresetDb.rawQuery(q);
  }
}
