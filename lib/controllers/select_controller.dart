import 'package:get/get.dart';

import "../models/chord.dart";
import "../utils/chord_table.dart";

class SelectController extends GetxController {
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

  bool isCheckedAt(int keyIndex, int suffixIndex) {
    return _checked[keyIndex][suffixIndex];
  }

  void set({List<Chord> checkedChords = const []}) {
    // Reset
    _selected = [];
    _checked = List.generate(
      keyListSharpUtil.length,
      (i) => List.generate(
        chordSuffixesUtil.length,
        (i) => false,
        growable: false,
      ),
      growable: false,
    );
    for (var chord in checkedChords) {
      select(chord.key, chord.suffixIndex);
    }
    update();
  }

  void setDiatonic(int keyIndex) {
    select(keyIndex, suffixIndexMapUtil['M']!);
    select(keyIndex, suffixIndexMapUtil['M7']!);
    select(keyIndex + 1, suffixIndexMapUtil['m']!);
    select(keyIndex + 1, suffixIndexMapUtil['m7']!);
    select(keyIndex + 2, suffixIndexMapUtil['m']!);
    select(keyIndex + 2, suffixIndexMapUtil['m7']!);
    select(keyIndex + 3, suffixIndexMapUtil['M']!);
    select(keyIndex + 3, suffixIndexMapUtil['M7']!);
    select(keyIndex + 4, suffixIndexMapUtil['M']!);
    select(keyIndex + 4, suffixIndexMapUtil['7']!);
    select(keyIndex + 4, suffixIndexMapUtil['sus4']!);
    select(keyIndex + 4, suffixIndexMapUtil['7sus4']!);
    select(keyIndex + 5, suffixIndexMapUtil['m']!);
    select(keyIndex + 5, suffixIndexMapUtil['m7']!);
    select(keyIndex + 6, suffixIndexMapUtil['dim']!);
    select(keyIndex + 6, suffixIndexMapUtil['m7♭5']!);
    update();
  }

  void select(int key, int suffixIndex) {
    if (_checked[key][suffixIndex] == true) return;
    /* TODO:
     * Remove input manipulation (converting to be within range 0~11) from high level function.
     * Move to wrapper implementation not to make user care of it.
     */
    _checked[key % 12][suffixIndex] = true;
    _selected.add(Chord(
      key: key,
      suffixIndex: suffixIndex,
    ));
    update();
  }

  void deselect(int key, int suffixIndex) {
    if (_checked[key][suffixIndex] == false) return;
    /* TODO:
     * Remove input manipulation (converting to be within range 0~11) from high level function.
     * Move to wrapper implementation not to make user care of it.
     */
    _checked[key % 12][suffixIndex] = false;
    _selected.removeWhere(
        (chord) => key == chord.key && suffixIndex == chord.suffixIndex);
    update();
  }
}
