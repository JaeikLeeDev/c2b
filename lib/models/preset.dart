import "../models/chord.dart";

/// 사용자가 만든 코드 모음 프리셋
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
