import "../utils/chord_table.dart";

class Chord {
  late final String name;
  final int key;
  final int suffix;

  Chord({required this.key, required this.suffix}) {
    name = keySuffixToString(key, suffix);
  }

  String keySuffixToString(int key, int suffix) {
    return '${keyListSharp[key]}${chordSuffix[suffix]}';
  }
}
