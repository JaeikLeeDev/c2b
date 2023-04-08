import 'package:get/get.dart';

import "../models/chord.dart";
import "../utils/chord_table.dart";

class SelectController extends GetxController {
  // List of chords from which the random chords are picked
  // Once setTraining() is called for the first time, it never become empty
  List<List<String>> _training = [];

  // List of chords currently selected on chordSelectScreen
  List<Chord> _selected = [];

  // Table of the entire chord and
  // T/F value that each chord has for representing if currently selected
  List<List<bool>> _checked = [];

  int _selectedKeyIndex = 0;

  @override
  void onInit() {
    set();
    super.onInit();
  }

  Chord atIndex(int index) {
    return _selected[index];
  }

  List<List<String>> getTraining() {
    return _training;
  }

  List<Chord> getSelected() {
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

  bool setTraining() {
    var curSelected = [
      ...getSelected().map(
        (chord) {
          return [chord.name(), chordNotesUtil(chord)];
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

  void setDiatonic() {
    // root
    select(_selectedKeyIndex, qualityIndexOf('M'));
    select(_selectedKeyIndex, qualityIndexOf('M7'));
    select(_selectedKeyIndex, qualityIndexOf('M9'));
    // 2 of the key
    select(_selectedKeyIndex + 2, qualityIndexOf('m'));
    select(_selectedKeyIndex + 2, qualityIndexOf('m7'));
    select(_selectedKeyIndex + 2, qualityIndexOf('m9'));
    // 3 of the key
    select(_selectedKeyIndex + 4, qualityIndexOf('m'));
    select(_selectedKeyIndex + 4, qualityIndexOf('m7'));
    select(_selectedKeyIndex + 4, qualityIndexOf('m7♭9'));
    // 4 of the key
    select(_selectedKeyIndex + 5, qualityIndexOf('M'));
    select(_selectedKeyIndex + 5, qualityIndexOf('M7'));
    select(_selectedKeyIndex + 5, qualityIndexOf('M9'));
    // 5 of the key
    select(_selectedKeyIndex + 7, qualityIndexOf('M'));
    select(_selectedKeyIndex + 7, qualityIndexOf('7'));
    select(_selectedKeyIndex + 7, qualityIndexOf('9'));
    select(_selectedKeyIndex + 7, qualityIndexOf('sus4'));
    select(_selectedKeyIndex + 7, qualityIndexOf('7sus4'));
    select(_selectedKeyIndex + 7, qualityIndexOf('9sus4'));
    // 6 of the key
    select(_selectedKeyIndex + 9, qualityIndexOf('m'));
    select(_selectedKeyIndex + 9, qualityIndexOf('m7'));
    select(_selectedKeyIndex + 9, qualityIndexOf('m9'));
    // 7 of the key
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
