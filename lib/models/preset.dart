import "../models/chord.dart";

class Preset {
  late final int id;
  late final String name;
  late final List<Chord> chordList;

  Preset({
    required this.id,
    required this.name,
    required this.chordList,
  });
}
