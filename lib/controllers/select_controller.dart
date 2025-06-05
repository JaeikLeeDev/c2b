import 'package:get/get.dart';

import "../models/chord.dart";
import "../utils/chord_table.dart";

/// ChordSelectScreen에서 필요한 데이터 및 기능을 다루는 Controller
class SelectController extends GetxController {
  /// 연습에 포함시킬 코드와 해당 코드 구성음 쌍을 요소로 갖는 리스트
  /// 이 리스트의 인덱스를 랜덤으로 뽑아 연습 화면에 해당 인덱스의 코드를 띄움
  /// ex)[["CM7", "C E G B"], ["Am","A C E"], ["Dm", "D F A"]]
  ///
  /// 최초 setTraining() 호출 후에는 empty가 되지 않음
  List<List<String>> _training = [];
  List<List<String>> get training {
    return _training;
  }

  /// _training을 생성, 초기화하는 함수
  /// chordSelectScreen에서 Done을 눌렀을 때 호출 -> 이후 trainingScreen으로 진입
  bool setTraining() {
    var curSelected = [
      ...selected.map(
        (chord) {
          return [
            chordNameUtil(_keyIndex, chord.rootIndex, chord.qualityIndex),
            chordNotesUtil(_keyIndex, chord.rootIndex, chord.qualityIndex),
          ];
        },
      )
    ];

    if (curSelected.isEmpty) {
      // Do nothing if user selected nothing
      return false;
    } else {
      // If user selected more than one,
      // replace the _training with that list
      _training.clear();
      _training = [for (var value in curSelected) List.from(value)];
      return true;
    }
  }

  /// 모든 코드 각각의 선택/미선택 상태 표시를 위한 boolean 리스트
  List<List<bool>> _checked = [];

  /// chordSelectScreen에서 선택한 코드 리스트
  /// 리스트의 각 요소(코드)는 Chord 객체
  List<Chord> _selected = [];
  List<Chord> get selected {
    return _selected;
  }

  /// _selected, _checked를 초기화/세팅하는 함수
  /// 최초 렌더링시, 사용자 코드모음 프리셋 적용시 호출
  void setSelected(List<Chord> checkedChords) {
    _selected = [];
    _checked = List.generate(
      numOfKeysUtil, // key의 개수 (12개)
      (i) => List.generate(
        qualityUtil.length, // 코드 quality(M, M7, m, m7, ...) 종류 개수
        (i) => false,
        growable: false,
      ),
      growable: false,
    );

    for (var chord in checkedChords) {
      select(chord.rootIndex, chord.qualityIndex);
    }
    update();
  }

  /// chordSelectScreen 앱바 key 드롭다운 리스트에서 현재 선택된 인덱스
  int _keyIndex = 0;
  int get keyIndex {
    return _keyIndex;
  }

  void setKeyIndex(int index) {
    _keyIndex = index;
    update();
  }

  /// chordSelectScreen 코드선택 섹션 좌측 루트노트 리스트에서 현재 선택된 인덱스
  int _rootIndex = 0;
  int get rootIndex {
    return _rootIndex;
  }

  set rootIndex(int index) {
    _rootIndex = index;
    update();
  }

  /// chordSelectScreen에서 현재 선택된 코드들의 목록을 따로 보여주는 데에 사용
  Chord atIndex(int index) {
    return _selected[index];
  }

  /// 현재 선택된 코드의 개수
  int length() {
    return _selected.length;
  }

  bool isEmpty() {
    return _selected.isEmpty;
  }

  bool isNotEmpty() {
    return _selected.isNotEmpty;
  }

  /// 코드 선택 체크박스가 있는 섹션은 한 루트(C/C#/D/...)의 코드만 qualityUtil의 qulity를 붙여서 나열하기 때문에 리스트의 길이, 순서는 qualityUtil과 동일함
  /// rootIndex는 이미 선택된 값이 있기 때문에 qualityUtil index만 있으면 전체 코드 리스트에서 특정 코드의 선택 여부 확인 가능
  bool isCheckedAt(int qualityIndex) {
    return _checked[_rootIndex][qualityIndex];
  }

  /// 현재 선택된 key의 diatonic 코드들을 모두 선택하는 함수
  void setDiatonic() {
    for (var e in diatonicUtil) {
      select(_keyIndex + e[0], e[1]);
    }
    update();
  }

  /// 각 코드를 선택할 때 호출되는 함수
  void select(int rootIndex, int qualityIndex) {
    int rootIndexBounded = rootIndex % 12;
    if (_checked[rootIndexBounded][qualityIndex] == true) return;
    /* TODO:
     * Remove input manipulation (converting to be within range 0~11) from high level function.
     * Move to wrapper implementation not to make user care of it.
     */
    _checked[rootIndexBounded][qualityIndex] = true;
    _selected.add(Chord(
      rootIndex: rootIndexBounded,
      qualityIndex: qualityIndex,
    ));
    update();
  }

  /// 각 코드를 선택 해제할 때 호출되는 함수
  void deselect(int rootIndex, int qualityIndex) {
    if (_checked[rootIndex][qualityIndex] == false) return;
    /* TODO:
     * Remove input manipulation (converting to be within range 0~11) from high level function.
     * Move to wrapper implementation not to make user care of it.
     */
    _checked[rootIndex % 12][qualityIndex] = false;
    _selected.removeWhere((chord) =>
        rootIndex == chord.rootIndex && qualityIndex == chord.qualityIndex);
    update();
  }

  @override
  void onInit() {
    setSelected(const []);
    super.onInit();
  }
}
