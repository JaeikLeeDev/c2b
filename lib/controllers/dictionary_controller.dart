import 'package:get/get.dart';

/*
 * For ChordDictionayScreen
 */
class DictionaryController extends GetxController {
  // Currently selected key
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
