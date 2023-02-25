import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import "../models/chord.dart";
import "../models/preset.dart";

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
  }

  Future<void> openDb() async {
    _chordPresetDb = await openDatabase(
      _databasesPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, chords TEXT)');
      },
    );
  }

  Future<void> closeDb() async {
    await _chordPresetDb.close();
  }

  Future<void> cleanUpDb() async {
    await closeDb();
    await deleteDatabase(_databasesPath);
  }

  Future<void> saveAsPreset(String presetName, List<Chord> chords) async {
    final preset = Preset(name: presetName, chordList: chords);

    await _chordPresetDb.transaction((txn) async {
      var id = await txn.rawInsert(
        'INSERT INTO $tableName(name, chords) VALUES(?, ?)',
        [presetName, preset.toString()],
      );
    });
  }

  Future<List<Preset>> getPresetList() async {
    final result = await _chordPresetDb.rawQuery('SELECT * FROM $tableName');
    return List.generate(
        result.length, (index) => Preset.fromDb(result[index]));
  }
}
