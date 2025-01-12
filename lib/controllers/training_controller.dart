import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:tonic/tonic.dart';

import '../controllers/select_controller.dart';
import '../utils/beep.dart';

class TrainingController extends GetxController {
  final SelectController _selectController = Get.find();

  /// 무작위 코드 모음 생성을 위한 Random 객체
  var rng = Random(DateTime.now().millisecond);

  /// 리스트 selectController.training의 인덱스[0, selectController.training.length] 중 파라미터 amount만큼 무작위로 뽑아 리스트로 return하는 함수
  List<int> _genRandChordIdxs(int amount) {
    List<int> randomChords = [];
    for (var i = 0; i < amount; i++) {
      randomChords.add(rng.nextInt(_selectController.training.length));
    }
    return randomChords;
  }

  /// 리스트 selectController.training의 인덱스 중 현재 연습화면에 보여줄 코드 개수(8개)만큼 무작위로 뽑은 리스트
  /// 각각의 수를 인덱스로 하여 현재 연습 화면에 보여줄 코드를 정하기 위함
  ///
  /// ex) 연습 화면 첫번째 코드: ```selectController.training[_tc.randomChordIndexList[0]]```
  final List<int> _randomChordIndexList = [];

  List<int> get randomChordIndexList {
    return _randomChordIndexList;
  }

  /// 연습 화면에 띄울 코드 모음을 생성하는 함수
  /// 최초 연습 화면을 그릴 때 호출
  void initRandomChord() {
    _randomChordIndexList.clear();
    _randomChordIndexList.addAll(_genRandChordIdxs(_chordPerPhrase * 2));
    update();
  }

  /* Beats
   * 악보 섹션에서 메트로놈의 진행에 맞춰 다음 코드로, 다음 phrase로 넘기기 위해 필요한 정보
   */

  /// 한 줄에 표시되는 코드의 개수
  final int _chordPerPhrase = 4;
  int get chordPerPhrase {
    return _chordPerPhrase;
  }

  /// Time siqnature top: 한 마디(코드 1개당 beat 수)
  int _beatsPerBar = 4;
  int get beatsPerBar {
    return _beatsPerBar;
  }

  /// 한 beat당 division 수 (더 작은 단위)
  int _meter = 1;
  int get meter {
    return _meter;
  }

  /// 연습 beat 진행 카운터
  /// 메트로놈(beat) timer 이벤트가 발생할 때마다 1씩 증가
  /// 0 <= (_divisionCounter) < (_beatsPerBar * _chordPerPhrase * _meter)
  int _divisionCounter = 0;
  int get divisionCounter {
    return _divisionCounter;
  }

  void _setDivisionCounter(int counter) {
    _divisionCounter = counter;
  }

  /// 현재 연습중인 코드의 인덱스
  /// 0 <= (_chordCounter) < (_chordPerPhrase)
  int _chordCounter = 0;
  int get chordCounter {
    return _chordCounter;
  }

  void _setChordCounter(int counter) {
    _chordCounter = counter;
  }

  /* Metronome */

  /// 메트로놈 소리
  final _beep = Beep();

  /// Beats Per Minute. 연습(메트로놈) 빠르기
  double _bpm = 60.0;
  double get bpm {
    return _bpm;
  }

  void setBpm(double newBpm) {
    _bpm = newBpm;
    update();
  }

  /// 설정한 속도에 맞춰 연습을 진행하기 위한 타이머
  /// 타이머 이벤트가 발생할 떄마다 _divisionCounter 증가
  late Timer _timer;

  bool _isTimerStarted = false;

  bool get isTimerStarted {
    return _isTimerStarted;
  }

  /* 연습 진행 */

  /// _divisionCounter 증가시키는 함수
  /// 매번 beat timer 이벤트 발생에 호출
  void nextDivision() {
    _divisionCounter =
        (_divisionCounter + 1) % (_beatsPerBar * _chordPerPhrase * _meter);
    update();
  }

  /// _chordCounter를 증가시키는 함수
  /// 다음 bar(다음 코드)로 넘어갈 때 호출
  void nextChord() {
    _chordCounter = (_chordCounter + 1) % _chordPerPhrase;
    _resetPianoState(); // 가상피아노모드인 경우, 선택된 건반 모두 클리어
    update();
  }

  /// 악보 다음 줄로 넘어갈 때 호출되는 함수
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

  /// 연습을 시작하는 함수
  Future<void> start() async {
    _beep.playB();
    _timer = Timer.periodic(
      Duration(
        milliseconds: (60 / (_bpm * _meter) * 1000).round(),
      ),
      (timer) {
        nextDivision();
        if (_divisionCounter % (_beatsPerBar * _meter) == 0) {
          // 코드 하나(bar 하나)에 나오는 beat 중 첫번째 beat. 조금 더 높은 음, 큰 소리
          _beep.playB();
          nextChord();
        } else {
          // 4 beat 중 2, 3, 4 beat. 첫 beat 보다 낮은 음, 작은 소리
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

  /// 연습을 중단(종료)하는 함수
  /// 연습 중 정보를 모두 리셋
  void stop() async {
    stopTimer();
    await _beep.stopBeat();
    _setChordCounter(0);
    _setDivisionCounter(0);
    _resetPianoState();
    update();
  }

  void stopTimer() {
    if (_isTimerStarted) {
      _timer.cancel();
    }
    _isTimerStarted = false;
  }

  /* 가상 건반 UI */

  /// 건반 범위: MIDI 기준 세번째 C(MIDI no. 24)부터
  static const int _octaveCount = 3;
  int get octaveCount {
    return _octaveCount;
  }

  /// 각 건반의 선택/미선택 상태 표시를 위한 리스트
  final List<bool> _pianoStates =
      List.generate(12 * (_octaveCount + 2), (_) => false);
  List<bool> get pianoStates {
    return _pianoStates;
  }

  /// 현재 선택된 건반의 인덱스의 set
  final Set<int> _selectedNotes = {};
  Set<int> get selected => _selectedNotes;
  List<int> get selectedList => _selectedNotes.toList()..sort();

  /// 건반을 선택/미선택 상태로 바꾸는 함수
  void togglePianoState(index) {
    _pianoStates[index] = !_pianoStates[index];
    if (_pianoStates[index] == true) {
      _selectedNotes.add(index);
    } else {
      _selectedNotes.remove(index);
    }
    update();
  }

  /// 모든 건반을 미선택 상태로 변경.
  void _resetPianoState() {
    for (int i = 0; i < _pianoStates.length; i++) {
      _pianoStates[i] = false;
    }
    _selectedNotes.clear();
  }

  /// 현재 선택된 건반의 음들을 문자열로 만들어주는 함수
  String selectedToString() {
    var sortedList = _selectedNotes.toList()..sort();
    String selected = "";
    for (var element in sortedList) {
      selected += '${Pitch.fromMidiNumber(element).pitchClass} ';
    }
    return selected;
  }

  /* 연습 관련 설정 */

  /// trainingScreen 연습 세팅 컨트롤 토글 버튼 세개
  ///
  /// ```onOffOptions[0]```: 코드 구성음 표시 ON/OFF
  ///
  /// ```onOffOptions[1]```: 윗줄 코드 4개만 반복 ON/OFF
  ///
  /// ```onOffOptions[2]```: 연습 모드 기본/가상피아노 전환
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

  /// 연습을 위해 뽑은 코드를 무작위로 섞는 함수
  void shuffle() {
    if (_onOffOptions[1]) {
      // 윗줄 반복 모드 ON 경우, 윗줄에 있는 코드를 순서만 바꿈.
      var phrase = _randomChordIndexList.sublist(0, _chordPerPhrase);
      phrase.shuffle();
      _randomChordIndexList.replaceRange(
        0,
        _chordPerPhrase,
        phrase,
      );
    } else {
      // 윗줄 반복 모드 아닌 경우, chordSelectionScreen에서 선택한 코드 풀 전체에서 다시 무작위로 코드 뽑기
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
