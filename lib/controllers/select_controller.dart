import 'package:get/get.dart';

import "../models/chord.dart";
import "../utils/chord_table.dart";

class SelectController extends GetxController {
  int _selectedKeyIndex = 0;
  List<Chord> _selected = [];
  List<List<bool>> _checked = [];
  List<List<String>> chordList = [];

  @override
  void onInit() {
    set();
    super.onInit();
  }

  Chord atIndex(int index) {
    return _selected[index];
  }

  List<List<String>> getTrainingList() {
    return chordList;
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

  void setChordList() {
    var curSelected = [
      ...get().map(
        (chord) {
          return [chord.name(), chordNotesUtil(chord)];
        },
      )
    ];
    // Do nothing if user selected nothing
    if (curSelected.isEmpty) return;

    // If user selected more than one, replace the list of the chord with that
    chordList.clear();
    chordList = [for (var value in chordList) List.from(value)];
  }

  void setDiatonic() {
    select(_selectedKeyIndex, qualityIndexOf('M'));
    select(_selectedKeyIndex, qualityIndexOf('M7'));
    select(_selectedKeyIndex, qualityIndexOf('M9'));
    select(_selectedKeyIndex + 2, qualityIndexOf('m'));
    select(_selectedKeyIndex + 2, qualityIndexOf('m7'));
    select(_selectedKeyIndex + 2, qualityIndexOf('m9'));
    select(_selectedKeyIndex + 4, qualityIndexOf('m'));
    select(_selectedKeyIndex + 4, qualityIndexOf('m7'));
    select(_selectedKeyIndex + 4, qualityIndexOf('m7♭9'));
    select(_selectedKeyIndex + 5, qualityIndexOf('M'));
    select(_selectedKeyIndex + 5, qualityIndexOf('M7'));
    select(_selectedKeyIndex + 5, qualityIndexOf('M9'));
    select(_selectedKeyIndex + 7, qualityIndexOf('M'));
    select(_selectedKeyIndex + 7, qualityIndexOf('7'));
    select(_selectedKeyIndex + 7, qualityIndexOf('9'));
    select(_selectedKeyIndex + 7, qualityIndexOf('sus4'));
    select(_selectedKeyIndex + 7, qualityIndexOf('7sus4'));
    select(_selectedKeyIndex + 7, qualityIndexOf('9sus4'));
    select(_selectedKeyIndex + 9, qualityIndexOf('m'));
    select(_selectedKeyIndex + 9, qualityIndexOf('m7'));
    select(_selectedKeyIndex + 9, qualityIndexOf('m9'));
    select(_selectedKeyIndex + 11, qualityIndexOf('dim'));
    select(_selectedKeyIndex + 11, qualityIndexOf('m7♭5'));
    select(_selectedKeyIndex + 11, qualityIndexOf('m7♭9♭5'));
    update();
  }

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
