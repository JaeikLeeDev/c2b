/// 코드 하나를 나타내는 객체.
///
/// 코드는 root(근음)와 quality(화성)로 표현됨.
/// root: 코드를 구성하는 음 중 가장 낮은 음.
/// quality: 근음을 기반으로 코드를 구성하는 음을 쌓는 규칙.
/// 예를 들어, CM7 코드의 root는 C, quality는 M7.
class Chord {
  /// utils/chord_table.dart의 리스트 keyListUtil의 인덱스
  late final int rootIndex;

  /// utils/chord_table.dart의 리스트 qualityUtil의 인덱스
  late final int qualityIndex;

  Chord({required this.rootIndex, required this.qualityIndex});
}
