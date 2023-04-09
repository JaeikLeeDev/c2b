import 'dart:async';
import 'dart:math';

import 'package:c2b/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/select_controller.dart';
import '../controllers/training_controller.dart';
import "../utils/preset_database.dart";
import '../utils/beep.dart';
import '../widgets/score.dart';
import '../widgets/beat_indicator.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final SelectController _selectController = Get.find();
  final _trainingController = Get.put(TrainingController());
  final _presetDb = PresetDatabase();
  var rng = Random(DateTime.now().millisecond);

  // A sequence of 8 random numbers and each number is randomly picked in
  // range [0, length of training chord list]
  final List<int> _randomChordIndexList = [];

  // Time siqnature top: the number of beats in a bar
  int _beatsPerBar = 4;

  // The number of chords(measures) per a phrase
  int _chordPerPhrase = 4;

  // The number of divisions in one beat
  int _meter = 1;

  // Increses at every timer event
  // Range: [0, _beatsPerBar * _chordPerPhrase * _meter)
  int _divisionCounter = 0;

  // Index of chord that is currently playing
  // Rnage: [0, _chordPerPhrase)
  int _chordCounter = 0;

  late Timer _timer;
  bool _isTimerStarted = false;

  // For sound
  final _beep = Beep();

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
    if (_trainingController.onOffOptions[1]) {
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
    _beep.playB();
    _timer = Timer.periodic(
      Duration(
        milliseconds: (60 / (_trainingController.bpm * _meter) * 1000).round(),
      ),
      (timer) {
        setState(() {
          _divisionCounter = (_divisionCounter + 1) %
              (_beatsPerBar * _chordPerPhrase * _meter);
        });
        if (_divisionCounter % (_beatsPerBar * _meter) == 0) {
          // 1st beat
          _beep.playB();
          _nextChord();
        } else {
          // 2nd, 3rd, 4th beat
          _beep.playA();
        }
        if (_divisionCounter == 0 &&
            _trainingController.onOffOptions[1] == false) {
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
    await _beep.stopBeat();
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
    _beep.init();
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
      body: GetBuilder<TrainingController>(
        builder: (controller) {
          return SafeArea(
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
                            value: _beep.volume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 20,
                            label:
                                'vol: ${(_beep.volume * 100).toStringAsFixed(0)}',
                            onChanged: (newVolume) {
                              setState(() {
                                _beep.updateVolume(newVolume);
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
                          isSelected: controller.onOffOptions,
                          onPressed: (idx) => controller.toggleOption(idx),
                          children: const [
                            Icon(Icons.abc), // Show/Hide chord notes
                            Icon(Icons.repeat), // ON/OFF interval repetition
                          ],
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
                            value: controller.bpm,
                            min: 20,
                            max: 180,
                            divisions: 160,
                            label: '${controller.bpm.toStringAsFixed(1)}bpm',
                            onChanged: (bpm) => controller.setBpm(bpm),
                            activeColor: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Score(
                    controller.onOffOptions[0],
                    randomChordIndexList: _randomChordIndexList,
                    chordCounter: _chordCounter,
                    chordPerPhrase: _chordPerPhrase,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
