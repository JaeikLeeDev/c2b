import "../models/chord.dart";

class Preset {
  // final int id;
  late final String name;
  late final List<Chord> chordList;

  Preset({
    // required this.id,
    required this.name,
    required this.chordList,
  });

  Preset.fromDb(Map<String, Object?> result) {
    name = result['name'] as String;
    chordList = _toChordList(result['chords'].toString());
  }

  @override
  String toString() {
    final encodedChords = List.generate(
        chordList.length, (index) => chordList[index].encodedChord);
    return encodedChords.join(',');
  }

  List<Chord> _toChordList(String encodedChordStr) {
    final encodedChords = encodedChordStr.split(',');
    return List.generate(
        encodedChords.length, (index) => Chord.fromCode(encodedChords[index]));
  }
}
