import 'package:get/get.dart';

class DictionaryController extends GetxController {
  int _keyIndex = 0;

  int get keyIndex {
    return _keyIndex;
  }

  void setKeyIndex(int index) {
    _keyIndex = index;
    update();
  }

  int _rootIndex = 0;

  int get rootIndex {
    return _rootIndex;
  }

  set rootIndex(int index) {
    _rootIndex = index;
    update();
  }
}
