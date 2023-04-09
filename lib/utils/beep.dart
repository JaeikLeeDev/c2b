import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';

class Beep {
  Beep._();
  static final Beep _instance = Beep._();
  factory Beep() {
    return _instance;
  }

  bool _isInit = false;
  final _soundpoolOptions =
      const SoundpoolOptions(streamType: StreamType.notification);
  late Soundpool _pool;
  int? _soundBStreamId;
  int? _soundAStreamId;
  late final Future<int> _soundBId;
  late final Future<int> _soundAId;
  double _volume = 0.5;

  double get volume => _volume;
  // set volume(double volume) => _volume = volume;

  Future<int> _loadSound(String filePath) async {
    var asset = await rootBundle.load(filePath);
    return await _pool.load(asset);
  }

  void init() {
    if (_isInit) return;
    _pool = Soundpool.fromOptions(options: _soundpoolOptions);
    _soundBId = _loadSound("assets/audio/assets_tone_tone1_b.wav");
    _soundAId = _loadSound("assets/audio/assets_tone_tone1_a.wav");
    playB();
    playA();
    _isInit = true;
  }

  Future<void> playB() async {
    var soundBId = await _soundBId;
    _pool.setVolume(soundId: soundBId, volume: _volume);
    _soundBStreamId = await _pool.play(soundBId);
  }

  Future<void> playA() async {
    var soundAId = await _soundAId;
    _pool.setVolume(soundId: soundAId, volume: _volume);
    _soundAStreamId = await _pool.play(soundAId);
  }

  Future<void> stopBeat() async {
    if (_soundBStreamId != null) {
      await _pool.stop(_soundBStreamId!);
    }
    if (_soundAStreamId != null) {
      await _pool.stop(_soundAStreamId!);
    }
  }

  Future<void> updateVolume(newVolume) async {
    _volume = newVolume;
    var soundBId = await _soundBId;
    _pool.setVolume(soundId: soundBId, volume: _volume);
    var soundAId = await _soundAId;
    _pool.setVolume(soundId: soundAId, volume: _volume);
  }
}
