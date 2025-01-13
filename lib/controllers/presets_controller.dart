import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

import '../models/chord.dart';
import '../models/preset.dart';

/// 사용자가 생성한 코드 모음 프리셋 관련 데이터와 기능을 다루는 Controller
class PresetsController extends GetxController {
  /// sqflite 로컬 데이터베이스
  late Database _db;

  /// sqflite 데이터베이스 _db가 열려있는지 나타내는 값. 열려있는 경우 True.
  bool _isOpen = false;

  final String _tableName = 'Presets';
  final String _dbName = 'c2b_jaeiklee_chord_presets.db';
  final String _schema = '''(id INTEGER PRIMARY KEY AUTOINCREMENT,
                             name TEXT,
                             chords TEXT)''';
  late final String _path;

  /// 사용자가 생성한 코드 모음 프리셋의 리스트
  List<Preset> _presetList = [];
  List<Preset> get presetList {
    return _presetList;
  }

  /// 선택된 코드 모음을 프리셋으로 저장하는 함수
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

  /// 특정 id의 프리셋을 삭제하는 함수
  Future<void> deletePreset(int id) async {
    if (!_isOpen) return;

    await _db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchPresetList();
  }

  /// sqflite 데이터베이스에서 프리셋들을 가져오는 함수.
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

  /// 프리셋에 포함된 코드들을 <코드의 근음>-<chord_table util 코드의 quality 인덱스>로 인코딩하고 ','로 구분하여 문자열로 만드는 함수.
  /// 각 프리셋을 텍스트 형태로 저장하기 위함.
  /// 문자열로 인코딩 결과 예시: "0-3,0-14,0-15,0-18,2-0,2-1,2-5,4-0,4-1,4-3,5-14,5-15,5-18"
  String _encode(List<Chord> chords) {
    final encodedChordList = List.generate(chords.length, (index) {
      return '${chords[index].rootIndex}-${chords[index].qualityIndex}';
    });
    final encodedPreset = encodedChordList.join(',');
    print(encodedPreset);
    return encodedPreset;
  }

  /// <코드의 근음>-<chord_table util 코드의 quality 인덱스>로 인코딩된 문자열을
  /// 디코딩하여 Chord 객체의 리스트로 return하는 함수.
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

  /// PresetController를 시작하는 함수
  Future<void> _init() async {
    var path = await getDatabasesPath();
    _path = join(path, _dbName);
    await _open();
    _fetchPresetList();
  }

  /// sqflite 데이터베이스를 여는 함수
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

  /// sqflite 데이터베이스를 닫는 함수
  Future<void> _close() async {
    if (!_isOpen) return;

    await _db.close();
    _isOpen = false;
  }

  /// 프리셋이 저장돼있는 데이터베이스를 삭제하는 함수.
  /// 모든 프리셋을 한번에 삭제하려고할 때 사용.
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
