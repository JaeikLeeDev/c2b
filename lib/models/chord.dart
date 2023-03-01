import 'package:get/get.dart';

import "../utils/chord_table.dart";
import '../controllers/select_controller.dart';

class Chord {
  late final int rootIndex;
  late final int qualityIndex;

  Chord({required this.rootIndex, required this.qualityIndex});

  String name() {
    final SelectController selectController = Get.find();
    return isSharpGroup(selectController.getKeyIndex())
        ? '${rootListSharpUtil[rootIndex]}${qualityToStringUtil(qualityIndex)}'
        : '${rootListFlatUtil[rootIndex]}${qualityToStringUtil(qualityIndex)}';
  }
}
