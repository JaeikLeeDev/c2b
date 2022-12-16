import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:audioplayers/audioplayers.dart';

import '../widget/bar.dart';

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
  final _chordList = [
    ["CM", 'C E G'],
    ["C#M", 'C# E# G#'],
    ["DM", 'D F# A'],
    ["EbM", 'Eb G Bb'],
    ["EM", 'E G# B'],
    ["FM", 'F A C'],
    ["F#M", 'F# A# C#'],
    ["GM", 'G B D'],
    ["AbM", 'Ab C Eb'],
    ["AM", 'A C# E'],
    ["BbM", 'Bb D F'],
    ["BM", 'B D# F#'],
    ["Cm", 'C Eb G'],
    ["C#m", 'C# E G#'],
    ["Dm", 'D F A'],
    ["Ebm", 'Eb Gb B'],
    ["Em", 'E G B'],
    ["Fm", 'F Ab C'],
    ["F#m", 'F# A C#'],
    ["Gm", 'G Bb D'],
    ["Abm", 'Ab Cb Eb'],
    ["Am", 'A C E'],
    ["Bbm", 'Bb Db F'],
    ["Bm", 'B D F#'],
  ];

  final _fMajorChordList = [
    ['FM', 'F A C'],
    ['FM7', 'F A C E'],
    ['Fsus4', 'F Bb C'],
    ['Gm', 'G Bb D'],
    ['Gm7', 'G Bb D F'],
    ['Gsus4', 'G C D'],
    ['Am', 'A C E'],
    ['Am7', 'A C E G'],
    ['Asus4', 'A D E'],
    ['BbM', 'Bb, D F'],
    ['BbM', 'Bb, D F A'],
    ['CM', 'C E G'],
    ['C7', 'C E G Bb'],
    ['Csus4', 'C F G'],
    ['Dm', 'D F A'],
    ['Dm7', 'D F A C'],
    ['Dsus4', 'D G A'],
    ['Edim', 'E G Bb'],
    ['Em7(b5)', 'E G Bb D'],
  ];

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

  late Timer _timer;
  var _codeCounter = 0;
  int _beatCounter = 0;
  bool _isTimerStarted = false;
  double _bpm = 60.0;
  int _beatSet = 4;
  int _codePerLine = 4;

  Future<void> _startTimer() async {
    _timer =
        Timer.periodic(Duration(milliseconds: (60 / _bpm * 1000).round()), (t) {
      setState(() {
        _beatCounter = (_beatCounter + 1) % (_beatSet * _codePerLine);
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
      _codeCounter = (_codeCounter + 1) % 4;
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

  void _stopTimer() {
    _stopBeat();
    _timer.cancel();
    setState(() {
      _codeCounter = 0;
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

  Color _colorMetronomeIndicator(int indicatorNumber) {
    if ((_beatCounter % _beatSet) == indicatorNumber) {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
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
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('metronome'),
                  ),
                  _isTimerStarted
                      ? ElevatedButton(
                          onPressed: _stopTimer,
                          child: const Icon(Icons.stop_circle))
                      : ElevatedButton(
                          onPressed: _startTimer,
                          child: const Icon(Icons.play_circle),
                        ),
                  if (mq.orientation == Orientation.landscape)
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
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _colorMetronomeIndicator(0),
                        ),
                        CircleAvatar(
                            backgroundColor: _colorMetronomeIndicator(1)),
                        CircleAvatar(
                            backgroundColor: _colorMetronomeIndicator(2)),
                        CircleAvatar(
                            backgroundColor: _colorMetronomeIndicator(3)),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bar(
                      chord: _chordList[_randomChordIndexList[0]],
                      isCur: 0 == _codeCounter,
                    ),
                    Bar(
                      chord: _chordList[_randomChordIndexList[1]],
                      isCur: 1 == _codeCounter,
                    ),
                    Bar(
                      chord: _chordList[_randomChordIndexList[2]],
                      isCur: 2 == _codeCounter,
                    ),
                    Bar(
                      chord: _chordList[_randomChordIndexList[3]],
                      isCur: 3 == _codeCounter,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Bar(
                      chord: _chordList[_randomChordIndexList[4]],
                      isCur: 4 == _codeCounter,
                    ),
                    Bar(
                      chord: _chordList[_randomChordIndexList[5]],
                      isCur: 5 == _codeCounter,
                    ),
                    Bar(
                      chord: _chordList[_randomChordIndexList[6]],
                      isCur: 6 == _codeCounter,
                    ),
                    Bar(
                      chord: _chordList[_randomChordIndexList[7]],
                      isCur: 7 == _codeCounter,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
