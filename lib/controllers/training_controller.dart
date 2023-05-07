import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:tonic/tonic.dart';

import '../controllers/select_controller.dart';
import '../utils/beep.dart';

class TrainingController extends GetxController {
  /* Options
   * onOffOptions[0]: answer ON/OFF
   * onOffOptions[1]: interval repetition ON/OFF
   * onOffOptions[2]: training method
   */
  final List<bool> _onOffOptions = [true, false, false];

  List<bool> get onOffOptions {
    return _onOffOptions;
  }

  bool get answerOn {
    return _onOffOptions[0];
  }

  bool get repeatOn {
    return _onOffOptions[1];
  }

  bool get pianoOn {
    return _onOffOptions[2];
  }

  void toggleOption(int index) {
    _onOffOptions[index] = !_onOffOptions[index];
    update();
  }

  /* Beats */

  // The number of chords(measures) per a phrase
  final int _chordPerPhrase = 4;

  // Time siqnature top: the number of beats in a bar
  int _beatsPerBar = 4;

  // The number of divisions in one beat
  int _meter = 1;

  // Increses at every timer event
  // Range: [0, _beatsPerBar * _chordPerPhrase * _meter)
  int _divisionCounter = 0;

  // Index of chord that is currently playing
  // Rnage: [0, _chordPerPhrase)
  int _chordCounter = 0;

  int get chordPerPhrase {
    return _chordPerPhrase;
  }

  int get beatsPerBar {
    return _beatsPerBar;
  }

  int get meter {
    return _meter;
  }

  int get divisionCounter {
    return _divisionCounter;
  }

  int get chordCounter {
    return _chordCounter;
  }

  void nextChord() {
    _chordCounter = (_chordCounter + 1) % _chordPerPhrase;
    update();
  }

  void setChordCounter(int counter) {
    _chordCounter = counter;
    update();
  }

  void nextDivision() {
    _divisionCounter =
        (_divisionCounter + 1) % (_beatsPerBar * _chordPerPhrase * _meter);
    update();
  }

  void setDivisionCounter(int counter) {
    _divisionCounter = counter;
    update();
  }

  /* Metronome */

  // sound
  final _beep = Beep();

  double _bpm = 60.0;
  late Timer _timer;
  bool _isTimerStarted = false;

  bool get isTimerStarted {
    return _isTimerStarted;
  }

  double get bpm {
    return _bpm;
  }

  void setBpm(double newBpm) {
    _bpm = newBpm;
    update();
  }

  Future<void> start() async {
    _beep.playB();
    _timer = Timer.periodic(
      Duration(
        milliseconds: (60 / (_bpm * _meter) * 1000).round(),
      ),
      (timer) {
        nextDivision();
        if (_divisionCounter % (_beatsPerBar * _meter) == 0) {
          // 1st beat
          _beep.playB();
          nextChord();
        } else {
          // 2nd, 3rd, 4th beat
          _beep.playA();
        }
        if (_divisionCounter == 0 && _onOffOptions[1] == false) {
          _nextPhrase();
        }
      },
    );
    _isTimerStarted = true;
    update();
  }

  void stop() async {
    stopTimer();
    await _beep.stopBeat();
    setChordCounter(0);
    setDivisionCounter(0);
  }

  void stopTimer() {
    if (_isTimerStarted) {
      _timer.cancel();
    }
    _isTimerStarted = false;
    update();
  }

  /* Chord's Note Quiz */

  // Start from 24(C1)
  static const int _octaveCount = 3;
  final List<bool> _noteStates =
      List.generate(12 * (_octaveCount + 2), (_) => false);
  final Set<int> _selected = {};

  int get octaveCount {
    return _octaveCount;
  }

  List<bool> get noteStates {
    return _noteStates;
  }

  void toggleNoteState(index) {
    _noteStates[index] = !_noteStates[index];
    if (_noteStates[index] == true) {
      _selected.add(index);
    } else {
      _selected.remove(index);
    }
    update();
  }

  Set<int> get selected => _selected;
  List<int> get selectedList => _selected.toList()..sort();

  String selectedToString() {
    var sortedList = _selected.toList()..sort();
    String selected = "";
    for (var element in sortedList) {
      selected += '${Pitch.fromMidiNumber(element).pitchClass} ';
    }
    return selected;
  }

  /* Random Training Chord List */

  final SelectController _selectController = Get.find();

  // A sequence of 8 random numbers and each number is randomly picked in
  // range [0, length of training chord list]
  final List<int> _randomChordIndexList = [];

  List<int> get randomChordIndexList {
    return _randomChordIndexList;
  }

  var rng = Random(DateTime.now().millisecond);
  List<int> _genRandChordIdxs(int amount) {
    List<int> randomChords = [];
    for (var i = 0; i < amount; i++) {
      randomChords.add(rng.nextInt(_selectController.training.length));
    }
    return randomChords;
  }

  void initRandomChord() {
    _randomChordIndexList.clear();
    _randomChordIndexList.addAll(_genRandChordIdxs(_chordPerPhrase * 2));
    update();
  }

  void _nextPhrase() {
    _randomChordIndexList.replaceRange(
      0,
      _chordPerPhrase,
      _randomChordIndexList.sublist(_chordPerPhrase, _chordPerPhrase * 2),
    );
    _randomChordIndexList.replaceRange(
      _chordPerPhrase,
      _chordPerPhrase * 2,
      _genRandChordIdxs(4),
    );
    update();
  }

  void shuffle() {
    if (_onOffOptions[1]) {
      var phrase = _randomChordIndexList.sublist(0, _chordPerPhrase);
      phrase.shuffle();
      _randomChordIndexList.replaceRange(
        0,
        _chordPerPhrase,
        phrase,
      );
    } else {
      _randomChordIndexList.replaceRange(
        0,
        _chordPerPhrase * 2,
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
