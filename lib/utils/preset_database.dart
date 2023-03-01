import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import "../models/chord.dart";
import "../models/preset.dart";

class PresetDatabase {
  PresetDatabase._();
  static final PresetDatabase _instance = PresetDatabase._();
  factory PresetDatabase() {
    return _instance;
  }

  bool _isOpened = false;
  bool _isInit = false;
  final String _tableName = 'Presets';
  final String _dbName = 'c2b_jaeiklee_chord_presets.db';
  late final String _databasesPath;
  late Database _chordPresetDb;

  Future<void> init() async {
    await getDbPath();
    await openDb();
    _isInit = true;
  }

  Future<void> getDbPath() async {
    if (_isInit) return;
    var path = await getDatabasesPath();
    _databasesPath = join(path, _dbName);
  }

  Future<void> openDb() async {
    if (_isOpened) return;

    _chordPresetDb = await openDatabase(
      _databasesPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, chords TEXT)');
      },
    );
    _isOpened = true;
  }

  // Out of the class, `closeDb()` should be called nowhere
  // but only in the top node of the widget tree
  // since PresetDatabase is singleton.
  Future<void> closeDb() async {
    if (_isOpened) return;

    await _chordPresetDb.close();
    _isOpened = false;
  }

  Future<void> cleanUpDb() async {
    await closeDb();
    await deleteDatabase(_databasesPath);
    await openDb();
  }

  Future<void> saveAsPreset(String presetName, List<Chord> chords) async {
    final encodedPreset = _encode(chords);
    await _chordPresetDb.transaction((txn) async {
      var id = await txn.rawInsert(
        'INSERT INTO $_tableName(name, chords) VALUES(?, ?)',
        [presetName, encodedPreset],
      );
    });
  }

  Future<void> deletePreset(int id) async {
    await _chordPresetDb.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Preset>> getPresetList() async {
    final presetList =
        await _chordPresetDb.rawQuery('SELECT * FROM $_tableName');

    return List.generate(presetList.length, (index) {
      var id = presetList[index]['id'] as int;
      var name = presetList[index]['name'] as String;
      var chordList = _decode(presetList[index]['chords'] as String);
      return Preset(id: id, name: name, chordList: chordList);
    });
  }

  String _encode(List<Chord> chords) {
    final encodedChordList = List.generate(chords.length, (index) {
      return '${chords[index].rootIndex}-${chords[index].qualityIndex}';
    });
    final encodedPreset = encodedChordList.join(',');
    return encodedPreset;
  }

  List<Chord> _decode(String encodedPreset) {
    var encodedChordList = encodedPreset.split(',');
    return List.generate(encodedChordList.length, (index) {
      final decodedChord = encodedChordList[index].split('-');
      final rootIndex = int.parse(decodedChord[0]);
      final qualityIndex = int.parse(decodedChord[1]);
      return Chord(
        rootIndex: rootIndex,
        qualityIndex: qualityIndex,
      );
    });
  }
}
