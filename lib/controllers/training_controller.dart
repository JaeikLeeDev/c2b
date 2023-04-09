import 'package:get/get.dart';

class TrainingController extends GetxController {
  // onOffOptions[0]: answer ON/OFF
  // onOffOptions[1]: interval repetition ON/OFF
  List<bool> onOffOptions = [true, false];
  double bpm = 60.0;

  void setBpm(double newBpm) {
    bpm = newBpm;
    update();
  }

  void toggleOption(int index) {
    onOffOptions[index] = !onOffOptions[index];
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
