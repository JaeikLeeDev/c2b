import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import 'package:soundpool/soundpool.dart';
import 'package:get/get.dart';

import "utils/chord_table.dart";
import "utils/preset_database.dart";
import 'widget/score.dart';
import 'widget/beat_indicator.dart';
import 'widget/chord_set_button.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  debugRepaintRainbowEnabled = true;
  // debugRepaintTextRainbowEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'C2B',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 30),
          )),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _presetDb = PresetDatabase();
  List<List<String>> _chordList = [];
  var rng = Random(DateTime.now().millisecond);
  final List<int> _randomChordIndexList = [];

  final int _beatSet = 4;
  final int _chordPerLine = 4;
  late Timer _timer;
  bool _isTimerStarted = false;
  double _bpm = 60.0;
  var _chordCounter = 0;
  int _beatCounter = 0;
  bool _chordConstructOn = true;
  double _beatVolume = 0.5;

  // For sound
  final _soundpoolOptions =
      const SoundpoolOptions(streamType: StreamType.notification);
  late Soundpool _pool;

  int? _firstBeatStreamId;
  int? _secondBeatStreamId;
  late Future<int> _firstBeatSoundId;
  late Future<int> _secondBeatSoundId;

  void _nextChord() {
    setState(() {
      _chordCounter = (_chordCounter + 1) % 4;
    });
  }

  void _nextPhrase() {
    setState(() {
      _randomChordIndexList.replaceRange(
          0, 3, _randomChordIndexList.sublist(4, 7));
      _randomChordIndexList.replaceRange(
        4,
        7,
        genRandChordIdxs(4),
      );
    });
  }

  void _setChordTrainingSet(List<List<String>> chordTrainingSet) {
    if (chordTrainingSet.isEmpty) return;

    setState(() {
      _chordList.clear();
      _chordList = [for (var value in chordTrainingSet) List.from(value)];
      _randomChordIndexList.clear();
      _randomChordIndexList.addAll(genRandChordIdxs(8));
    });
  }

  List<int> genRandChordIdxs(int amount) {
    List<int> randomChords = [];
    for (var i = 0; i < amount; i++) {
      randomChords.add(rng.nextInt(_chordList.length));
    }
    return randomChords;
  }

  Future<void> _startTimer() async {
    _play1stBeat();
    _timer =
        Timer.periodic(Duration(milliseconds: (60 / _bpm * 1000).round()), (t) {
      setState(() {
        _beatCounter = (_beatCounter + 1) % (_beatSet * _chordPerLine);
      });
      if (_beatCounter % _beatSet == 0) {
        // 1st beat
        _play1stBeat();
        _nextChord();
      } else {
        // 2nd, 3rd, 4th beat
        _play2ndBeat();
      }
      if (_beatCounter == 0) {
        _nextPhrase();
      }
    });
    setState(() {
      _isTimerStarted = true;
    });
  }

  void _stop() async {
    if (_isTimerStarted) {
      _timer.cancel();
    }
    await _stopBeat();
    setState(() {
      _chordCounter = 0;
      _beatCounter = 0;
      _isTimerStarted = false;
    });
  }

  Future<int> _loadSound(String filePath) async {
    var asset = await rootBundle.load(filePath);
    return await _pool.load(asset);
  }

  Future<void> _play1stBeat() async {
    var firstBeatSound = await _firstBeatSoundId;
    _pool.setVolume(soundId: firstBeatSound, volume: _beatVolume);
    _firstBeatStreamId = await _pool.play(firstBeatSound);
  }

  Future<void> _play2ndBeat() async {
    var secondBeatSound = await _secondBeatSoundId;
    _pool.setVolume(soundId: secondBeatSound, volume: _beatVolume);
    _secondBeatStreamId = await _pool.play(secondBeatSound);
  }

  Future<void> _stopBeat() async {
    if (_firstBeatStreamId != null) {
      await _pool.stop(_firstBeatStreamId!);
    }
    if (_secondBeatStreamId != null) {
      await _pool.stop(_secondBeatStreamId!);
    }
  }

  Future<void> _updateVolume(newVolume) async {
    var firstBeatSound = await _firstBeatSoundId;
    _pool.setVolume(soundId: firstBeatSound, volume: newVolume);
    var secondBeatSound = await _secondBeatSoundId;
    _pool.setVolume(soundId: secondBeatSound, volume: newVolume);
  }

  @override
  void initState() {
    _presetDb.init();
    _pool = Soundpool.fromOptions(options: _soundpoolOptions);
    _firstBeatSoundId = _loadSound("assets/audio/assets_tone_tone1_b.wav");
    _secondBeatSoundId = _loadSound("assets/audio/assets_tone_tone1_a.wav");
    _play1stBeat();
    _play2ndBeat();
    _chordList.addAll(fMajorChordListUtil);
    _randomChordIndexList.addAll(genRandChordIdxs(8));
    super.initState();
  }

  @override
  void dispose() {
    _presetDb.closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return Scaffold(
      body: Center(
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
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                          // enabledThumbRadius: 10.0,
                          pressedElevation: 8.0,
                        ),
                      ),
                      child: Slider(
                        value: _beatVolume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: 'vol: ${_beatVolume.toStringAsFixed(1)}',
                        onChanged: (beatVolume) {
                          setState(() {
                            _beatVolume = beatVolume;
                          });
                          _updateVolume(_beatVolume);
                        },
                      ),
                    ),
                  ),
                  /* Show/Hide chord notes */
                  Switch.adaptive(
                    value: _chordConstructOn,
                    activeColor: Colors.blue,
                    onChanged: (onOff) {
                      setState(() {
                        _chordConstructOn = onOff;
                      });
                    },
                  ),
                  /* Go to chord selection screen */
                  ChordSetButton(_setChordTrainingSet, _stop),
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
                      currentBeat: (_beatCounter % _beatSet),
                      radius: mq.size.width * 0.02),
                  /* bpm slider */
                  SizedBox(
                    width: mq.size.width * 0.2,
                    child: Slider(
                      value: _bpm,
                      min: 40,
                      max: 180,
                      divisions: 280,
                      label: '${_bpm.toStringAsFixed(1)}bpm',
                      onChanged: (bpm) {
                        setState(() {
                          _bpm = bpm;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Score(
              _chordConstructOn,
              chordList: _chordList,
              randomChordIndexList: _randomChordIndexList,
              chordCounter: _chordCounter,
            ),
          ],
        ),
      ),
    );
  }
}
