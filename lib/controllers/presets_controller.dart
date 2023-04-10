import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

import '../models/chord.dart';
import '../models/preset.dart';

/* 
 * List of presets
 * 
 * Database opens when Get.put(PresetsController()) is called.
 * Database closes when the page which calls Get.put(PresetsController()) destroys.
 * 
 * Calling open() or close() outside the class is unnecessary.
 */
class PresetsController extends GetxController {
  bool _isOpen = false;
  final String _tableName = 'Presets';
  final String _dbName = 'c2b_jaeiklee_chord_presets.db';
  final String _schema = '''(id INTEGER PRIMARY KEY AUTOINCREMENT,
                             name TEXT,
                             chords TEXT)''';
  late final String _path;
  late Database _db;
  List<Preset> _presetList = [];

  List<Preset> get presetList {
    return _presetList;
  }

  Future<void> saveAsPreset(String presetName, List<Chord> chords) async {
    if (!_isOpen) return;

    final encodedPreset = _encode(chords);
    await _db.insert(
      _tableName,
      {'name': presetName, 'chords': encodedPreset},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchPresetList();
  }

  Future<void> deletePreset(int id) async {
    if (!_isOpen) return;

    await _db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchPresetList();
  }

  Future<void> _fetchPresetList() async {
    if (!_isOpen) return;

    final result = await _db.rawQuery('SELECT * FROM $_tableName');
    _presetList.clear();
    _presetList = List.generate(result.length, (index) {
      var id = result[index]['id'] as int;
      var name = result[index]['name'] as String;
      var chordList = _decode(result[index]['chords'] as String);
      return Preset(id: id, name: name, chordList: chordList);
    });
    update();
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

  Future<void> _init() async {
    var path = await getDatabasesPath();
    _path = join(path, _dbName);
    await _open();
    _fetchPresetList();
  }

  Future<void> _open() async {
    if (_isOpen) return;

    _db = await openDatabase(
      _path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE $_tableName $_schema');
      },
    );
    _isOpen = true;
  }

  Future<void> _close() async {
    if (!_isOpen) return;

    await _db.close();
    _isOpen = false;
  }

  Future<void> clear() async {
    await _close();
    await deleteDatabase(_path);
    await _open();
    _fetchPresetList();
  }

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  @override
  void onClose() {
    _close();
    super.onClose();
  }
}
