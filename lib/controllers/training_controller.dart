import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

import '../controllers/select_controller.dart';
import '../utils/beep.dart';

class TrainingController extends GetxController {
  /* Options
   * onOffOptions[0]: answer ON/OFF
   * onOffOptions[1]: interval repetition ON/OFF
   */
  List<bool> onOffOptions = [true, false];

  void toggleOption(int index) {
    onOffOptions[index] = !onOffOptions[index];
    update();
  }

  /* Beats */

  // The number of chords(measures) per a phrase
  final int chordPerPhrase = 4;

  // Time siqnature top: the number of beats in a bar
  int beatsPerBar = 4;

  // The number of divisions in one beat
  int meter = 1;

  // Increses at every timer event
  // Range: [0, _beatsPerBar * _chordPerPhrase * _meter)
  int divisionCounter = 0;

  // Index of chord that is currently playing
  // Rnage: [0, _chordPerPhrase)
  int chordCounter = 0;

  void nextChord() {
    chordCounter = (chordCounter + 1) % chordPerPhrase;
    update();
  }

  void setChordCounter(int counter) {
    chordCounter = counter;
    update();
  }

  void nextDivision() {
    divisionCounter =
        (divisionCounter + 1) % (beatsPerBar * chordPerPhrase * meter);
    update();
  }

  void setDivisionCounter(int counter) {
    divisionCounter = counter;
    update();
  }

  /* Metronome */

  // sound
  final _beep = Beep();

  double bpm = 60.0;
  late Timer timer;
  bool isTimerStarted = false;

  void setBpm(double newBpm) {
    bpm = newBpm;
    update();
  }

  Future<void> start() async {
    _beep.playB();
    timer = Timer.periodic(
      Duration(
        milliseconds: (60 / (bpm * meter) * 1000).round(),
      ),
      (timer) {
        nextDivision();
        if (divisionCounter % (beatsPerBar * meter) == 0) {
          // 1st beat
          _beep.playB();
          nextChord();
        } else {
          // 2nd, 3rd, 4th beat
          _beep.playA();
        }
        if (divisionCounter == 0 && onOffOptions[1] == false) {
          _nextPhrase();
        }
      },
    );
    isTimerStarted = true;
    update();
  }

  void stop() async {
    stopTimer();
    await _beep.stopBeat();
    setChordCounter(0);
    setDivisionCounter(0);
  }

  void stopTimer() {
    if (isTimerStarted) {
      timer.cancel();
    }
    isTimerStarted = false;
    update();
  }

  /* Random Training Chord List */

  // A sequence of 8 random numbers and each number is randomly picked in
  // range [0, length of training chord list]
  final List<int> randomChordIndexList = [];
  final SelectController _selectController = Get.find();

  var rng = Random(DateTime.now().millisecond);
  List<int> _genRandChordIdxs(int amount) {
    List<int> randomChords = [];
    for (var i = 0; i < amount; i++) {
      randomChords.add(rng.nextInt(_selectController.getTraining().length));
    }
    return randomChords;
  }

  void initRandomChord() {
    randomChordIndexList.clear();
    randomChordIndexList.addAll(_genRandChordIdxs(chordPerPhrase * 2));
    update();
  }

  void _nextPhrase() {
    randomChordIndexList.replaceRange(
      0,
      chordPerPhrase,
      randomChordIndexList.sublist(chordPerPhrase, chordPerPhrase * 2),
    );
    randomChordIndexList.replaceRange(
      chordPerPhrase,
      chordPerPhrase * 2,
      _genRandChordIdxs(4),
    );
    update();
  }

  void shuffle() {
    if (onOffOptions[1]) {
      var phrase = randomChordIndexList.sublist(0, chordPerPhrase);
      phrase.shuffle();
      randomChordIndexList.replaceRange(
        0,
        chordPerPhrase,
        phrase,
      );
    } else {
      randomChordIndexList.replaceRange(
        0,
        chordPerPhrase * 2,
        _genRandChordIdxs(8),
      );
    }
    update();
  }

  @override
  void onInit() {
    _beep.init();
    super.onInit();
  }
}
