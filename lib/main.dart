import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:audioplayers/audioplayers.dart';

import 'model/chord_list.dart';
import 'widget/score.dart';
import 'widget/beat_indicator.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C2B',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            bodyText1: TextStyle(fontSize: 30),
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
  final _chordList = ChordList.getFMajChordList();

  final playerABeat = AudioPlayer();
  final playerBBeat = AudioPlayer();

  Future<void> _setPlayer() async {
    await playerABeat
        .setSource(AssetSource('../assets/assets_tone_tone1_a.wav'));
    await playerBBeat
        .setSource(AssetSource('../assets/assets_tone_tone1_b.wav'));
  }

  Future<void> _playBeat(bool isFirstBeat) async {
    isFirstBeat
        ? await playerBBeat
            .play(AssetSource('../assets/assets_tone_tone1_b.wav'))
        : await playerABeat
            .play(AssetSource('../assets/assets_tone_tone1_a.wav'));
  }

  Future<void> _stopBeat() async {
    await playerABeat.stop();
    await playerBBeat.stop();
  }

  var rng = Random(DateTime.now().millisecond);
  final List<int> _randomChordIndexList = [];

  final int _beatSet = 4;
  final int _chordPerLine = 4;

  late Timer _timer;
  var _chordCounter = 0;
  int _beatCounter = 0;
  bool _isTimerStarted = false;
  double _bpm = 60.0;
  bool _chordConstructOn = true;

  Future<void> _startTimer() async {
    _timer =
        Timer.periodic(Duration(milliseconds: (60 / _bpm * 1000).round()), (t) {
      setState(() {
        _beatCounter = (_beatCounter + 1) % (_beatSet * _chordPerLine);
      });
      if (_beatCounter % _beatSet == 0) {
        _playBeat(true);
        _nextCode();
      } else {
        _playBeat(false);
      }
      if (_beatCounter == 0) {
        _nextPhrase();
      }
    });
    setState(() {
      _isTimerStarted = true;
    });
  }

  void _nextCode() {
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
        randomPhrase(),
      );
    });
  }

  void _stop() {
    _stopBeat();
    _timer.cancel();
    setState(() {
      _chordCounter = 0;
      _beatCounter = 0;
      _isTimerStarted = false;
    });
  }

  List<int> randomPhrase() {
    List<int> randomPhrase = [];
    for (var i = 0; i < 4; i++) {
      randomPhrase.add(rng.nextInt(_chordList.length));
    }
    return randomPhrase;
  }

  @override
  void initState() {
    _setPlayer();
    for (var i = 0; i < 8; i++) {
      _randomChordIndexList.add(rng.nextInt(_chordList.length));
    }
    super.initState();
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
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Switch(
                    value: _chordConstructOn,
                    activeColor: Colors.blue,
                    onChanged: (onOff) {
                      setState(() {
                        _chordConstructOn = onOff;
                      });
                    },
                  ),
                  _isTimerStarted
                      ? ElevatedButton(
                          onPressed: _stop,
                          child: const Icon(Icons.stop_circle))
                      : ElevatedButton(
                          onPressed: _startTimer,
                          child: const Icon(Icons.play_circle),
                        ),
                  if (mq.orientation == Orientation.landscape)
                    // bpm slider
                    Slider(
                        value: _bpm,
                        min: 40,
                        max: 180,
                        divisions: 280,
                        label: '${_bpm.toStringAsFixed(1)}bpm',
                        onChanged: (bpm) {
                          setState(() {
                            _bpm = bpm;
                          });
                        }),
                  if (mq.orientation == Orientation.landscape)
                    // beat indicator
                    BeatIndicator(beatCounter: _beatCounter, beatSet: _beatSet),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.settings),
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
