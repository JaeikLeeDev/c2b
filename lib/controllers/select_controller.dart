import 'package:get/get.dart';

import "../models/chord.dart";
import "../utils/chord_table.dart";

class SelectController extends GetxController {
  int _selectedKeyIndex = 0;
  List<Chord> _selected = [];
  List<List<bool>> _checked = [];

  @override
  void onInit() {
    set();
    super.onInit();
  }

  Chord atIndex(int index) {
    return _selected[index];
  }

  List<Chord> get() {
    return _selected;
  }

  int length() {
    return _selected.length;
  }

  bool isEmpty() {
    return _selected.isEmpty;
  }

  bool isNotEmpty() {
    return _selected.isNotEmpty;
  }

  bool isCheckedAt(int rootIndex, int qualityIndex) {
    return _checked[rootIndex][qualityIndex];
  }

  void setKeyIndex(int index) {
    _selectedKeyIndex = index;
  }

  int getKeyIndex() {
    return _selectedKeyIndex;
  }

  void set({List<Chord> checkedChords = const []}) {
    // Reset
    _selected = [];
    _checked = List.generate(
      numOfKeysUtil,
      (i) => List.generate(
        qualityUtil.length,
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

  void setDiatonic() {
    select(_selectedKeyIndex, qualityIndexOf('M'));
    select(_selectedKeyIndex, qualityIndexOf('M7'));
    select(_selectedKeyIndex + 1, qualityIndexOf('m'));
    select(_selectedKeyIndex + 1, qualityIndexOf('m7'));
    select(_selectedKeyIndex + 2, qualityIndexOf('m'));
    select(_selectedKeyIndex + 2, qualityIndexOf('m7'));
    select(_selectedKeyIndex + 3, qualityIndexOf('M'));
    select(_selectedKeyIndex + 3, qualityIndexOf('M7'));
    select(_selectedKeyIndex + 4, qualityIndexOf('M'));
    select(_selectedKeyIndex + 4, qualityIndexOf('7'));
    select(_selectedKeyIndex + 4, qualityIndexOf('sus4'));
    select(_selectedKeyIndex + 4, qualityIndexOf('7sus4'));
    select(_selectedKeyIndex + 5, qualityIndexOf('m'));
    select(_selectedKeyIndex + 5, qualityIndexOf('m7'));
    select(_selectedKeyIndex + 6, qualityIndexOf('dim'));
    select(_selectedKeyIndex + 6, qualityIndexOf('m7♭5'));
    update();
  }

  void select(int rootIndex, int qualityIndex) {
    if (_checked[rootIndex][qualityIndex] == true) return;
    /* TODO:
     * Remove input manipulation (converting to be within range 0~11) from high level function.
     * Move to wrapper implementation not to make user care of it.
     */
    _checked[rootIndex % 12][qualityIndex] = true;
    _selected.add(Chord(
      rootIndex: rootIndex,
      qualityIndex: qualityIndex,
    ));
    update();
  }

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
}
