import "../utils/chord_table.dart";

class Chord {
  late final int key;
  late final int suffixIndex;
  late final String name;
  late final String encodedChord;

  Chord({required this.key, required this.suffixIndex}) {
    name = _toChordString(key, suffixIndex);
    encodedChord = _toEncodedChordString(key, suffixIndex);
  }

  Chord.fromCode(String encodedChordString) {
    final chord = _toDecodedChord(encodedChordString);
    key = chord['key']!;
    suffixIndex = chord['suffixIndex']!;
    name = _toChordString(key, suffixIndex);
    encodedChord = _toEncodedChordString(key, suffixIndex);
  }

  // ex) D#sus4
  String _toChordString(int key, int suffixIndex) {
    return '${keyListSharpUtil[key]}${chordNameUtil(suffixIndex)}';
  }

  // ex) 3,5
  String _toEncodedChordString(int key, int suffixIndex) {
    return '$key-$suffixIndex';
  }

  Map<String, int> _toDecodedChord(String encodedChordString) {
    final decodedChord = encodedChordString.split('-');
    return {
      "key": int.parse(decodedChord[0]),
      "suffixIndex": int.parse(decodedChord[1]),
    };
  }

  Map<String, int> toDecodedChord() {
    final decodedChord = encodedChord.split('-');
    return {
      "key": int.parse(decodedChord[0]),
      "suffixIndex": int.parse(decodedChord[1]),
    };
  }
}
