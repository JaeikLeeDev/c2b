import "../utils/chord_table.dart";

class Chord {
  late final int key;
  late final int suffix;
  late final String name;
  late final String encodedChord;

  Chord({required this.key, required this.suffix}) {
    name = _toChordString(key, suffix);
    encodedChord = _toEncodedChordString(key, suffix);
  }

  Chord.fromCode(String encodedChordString) {
    final chord = _toDecodedChord(encodedChordString);
    key = chord['key']!;
    suffix = chord['suffix']!;
    name = _toChordString(key, suffix);
    encodedChord = _toEncodedChordString(key, suffix);
  }

  // ex) D#sus4
  String _toChordString(int key, int suffix) {
    return '${keyListSharp[key]}${chordSuffixes[suffix]}';
  }

  // ex) 3,5
  String _toEncodedChordString(int key, int suffix) {
    return '$key-$suffix';
  }

  Map<String, int> _toDecodedChord(String encodedChordString) {
    final decodedChord = encodedChordString.split('-');
    return {
      "key": int.parse(decodedChord[0]),
      "suffix": int.parse(decodedChord[1]),
    };
  }
}
