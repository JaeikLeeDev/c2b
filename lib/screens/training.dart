import 'dart:async';
import 'dart:math';

import 'package:c2b/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/select_controller.dart';
import "../utils/chord_table.dart";
import "../utils/preset_database.dart";
import "../utils/metronome.dart";
import '../widgets/score.dart';
import '../widgets/beat_indicator.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final SelectController _selectController = Get.find();
  final _presetDb = PresetDatabase();
  var rng = Random(DateTime.now().millisecond);
  final List<int> _randomChordIndexList = [];

  double _bpm = 60.0;
  int _beatsPerBar = 4; // Time siqnature top: the number of beats in a bar
  int _chordPerPhrase = 4; // The number of chords(measures) per a phrase
  int _meter = 1; // The number of divisions in one beat
  int _divisionCounter = 0; // [0, _timeSignTop * _chordPerPhrase * _meter)
  int _chordCounter = 0; // [0, _chordPerPhrase)

  late Timer _timer;
  bool _isTimerStarted = false;
  List<bool> _onOffOptions = [true, false];

  // For sound
  final _metronome = Metronome();

  void _nextChord() {
    setState(() {
      _chordCounter = (_chordCounter + 1) % _chordPerPhrase;
    });
  }

  void _nextPhrase() {
    setState(() {
      _randomChordIndexList.replaceRange(
        0,
        _chordPerPhrase,
        _randomChordIndexList.sublist(_chordPerPhrase, _chordPerPhrase * 2),
      );
      _randomChordIndexList.replaceRange(
        _chordPerPhrase,
        _chordPerPhrase * 2,
        genRandChordIdxs(4),
      );
    });
  }

  List<int> genRandChordIdxs(int amount) {
    List<int> randomChords = [];
    for (var i = 0; i < amount; i++) {
      randomChords.add(rng.nextInt(_selectController.getTraining().length));
    }
    return randomChords;
  }

  void _shuffle() {
    if (_onOffOptions[1]) {
      var phrase = _randomChordIndexList.sublist(0, _chordPerPhrase);
      phrase.shuffle();
      setState(() {
        _randomChordIndexList.replaceRange(
          0,
          _chordPerPhrase,
          phrase,
        );
      });
    } else {
      setState(() {
        _randomChordIndexList.replaceRange(
          0,
          _chordPerPhrase * 2,
          genRandChordIdxs(8),
        );
      });
    }
  }

  Future<void> _startTimer() async {
    _metronome.playSoundB();
    _timer = Timer.periodic(
      Duration(
        milliseconds: (60 / (_bpm * _meter) * 1000).round(),
      ),
      (timer) {
        setState(() {
          _divisionCounter = (_divisionCounter + 1) %
              (_beatsPerBar * _chordPerPhrase * _meter);
        });
        if (_divisionCounter % (_beatsPerBar * _meter) == 0) {
          // 1st beat
          _metronome.playSoundB();
          _nextChord();
        } else {
          // 2nd, 3rd, 4th beat
          _metronome.playSoundA();
        }
        if (_divisionCounter == 0 && _onOffOptions[1] == false) {
          _nextPhrase();
        }
      },
    );
    setState(() {
      _isTimerStarted = true;
    });
  }

  void _stop() async {
    if (_isTimerStarted) {
      _timer.cancel();
    }
    await _metronome.stopBeat();
    setState(() {
      _chordCounter = 0;
      _divisionCounter = 0;
      _isTimerStarted = false;
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _presetDb.init();
    _metronome.init();
    _randomChordIndexList.addAll(genRandChordIdxs(_chordPerPhrase * 2));
    super.initState();
  }

  @override
  void dispose() {
    if (_isTimerStarted) {
      _timer.cancel();
    }
    _presetDb.closeDb();
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /* volume slider */
                    SizedBox(
                      width: mq.size.width * 0.17,
                      child: Slider(
                        value: _metronome.volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 20,
                        label:
                            'vol: ${(_metronome.volume * 100).toStringAsFixed(0)}',
                        onChanged: (newVolume) {
                          setState(() {
                            _metronome.updateVolume(newVolume);
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                    ),
                    /* shuffle */
                    ElevatedButton(
                      onPressed: _shuffle,
                      child: const Icon(Icons.shuffle),
                    ),
                    /* ON/OFF options */
                    ToggleButtons(
                      children: [
                        Icon(Icons.abc), // Show/Hide chord notes
                        Icon(Icons.repeat), // ON/OFF interval repetition
                      ],
                      isSelected: _onOffOptions,
                      onPressed: (int index) {
                        setState(() {
                          _onOffOptions[index] = !_onOffOptions[index];
                        });
                      },
                    ),
                    /* Go to chord selection screen */
                    ElevatedButton(
                      onPressed: () {
                        _stop();
                        Get.offNamed('/chord_select');
                      },
                      child: const Icon(Icons.settings),
                    ),
                    /* Start/Stop Training */
                    _isTimerStarted
                        ? ElevatedButton(
                            onPressed: _stop,
                            child: const Icon(Icons.stop_circle),
                          )
                        : ElevatedButton(
                            onPressed: _startTimer,
                            child: const Icon(Icons.play_circle),
                          ),
                    /* beat indicator */
                    BeatIndicator(
                        currentBeat:
                            ((_divisionCounter % (_beatsPerBar * _meter)) /
                                    _meter)
                                .floor(),
                        beatsPerBar: _beatsPerBar,
                        radius: mq.size.width * 0.02),
                    /* bpm slider */
                    SizedBox(
                      width: mq.size.width * 0.2,
                      child: Slider(
                        value: _bpm,
                        min: 20,
                        max: 180,
                        divisions: 160,
                        label: '${_bpm.toStringAsFixed(1)}bpm',
                        onChanged: (bpm) {
                          setState(() {
                            _bpm = bpm;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Score(
                _onOffOptions[0],
                randomChordIndexList: _randomChordIndexList,
                chordCounter: _chordCounter,
                chordPerPhrase: _chordPerPhrase,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
