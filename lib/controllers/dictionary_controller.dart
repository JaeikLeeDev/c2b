import 'package:get/get.dart';

/// ChordDictionayScreen에서 필요한 데이터 및 기능을 다루는 Controller
class DictionaryController extends GetxController {
  /// key 선택 드롭다운을 통해 선택된 key의 인덱스
  int _keyIndex = 0;
  int get keyIndex {
    return _keyIndex;
  }

  void setKeyIndex(int index) {
    _keyIndex = index;
    update();
  }

  // Currently selected root
  int _rootIndex = 0;

  int get rootIndex {
    return _rootIndex;
  }

  set rootIndex(int index) {
    _rootIndex = index;
    update();
  }

  // true: show only diatonic chords
  // false: show all chords
  bool _showOnlyDiatonicOn = false;

  bool get showOnlyDiatonicOn {
    return _showOnlyDiatonicOn;
  }

  void toggleShowOnlyDiatonicOn() {
    _showOnlyDiatonicOn = !_showOnlyDiatonicOn;
    update();
  }
}
