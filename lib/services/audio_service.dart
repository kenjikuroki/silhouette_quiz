import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _buttonPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _cheerPlayer = AudioPlayer();
  final AudioPlayer _leverPlayer = AudioPlayer();
  final AudioPlayer _challengePlayer = AudioPlayer();
  final AudioPlayer _whistlePlayer = AudioPlayer();
  final AudioPlayer _fallBoxPlayer = AudioPlayer();
  final AudioPlayer _characterChangePlayer = AudioPlayer();
  String _currentBgmAsset = 'bgm/BGM.mp3';
  bool _muted = false;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(0.5);
    await _buttonPlayer.setVolume(0.2);
    await _effectPlayer.setVolume(0.5);
    await _cheerPlayer.setVolume(0.35);
    await _leverPlayer.setVolume(0.4);
    await _challengePlayer.setVolume(0.4);
    await _whistlePlayer.setVolume(0.4);
    await _fallBoxPlayer.setVolume(0.5);
    await _characterChangePlayer.setVolume(0.6);
    await _playBgm('bgm/BGM.mp3');
    _initialized = true;
  }

  Future<void> playButtonSound() async {
    if (!_initialized) {
      await initialize();
    }
    await _buttonPlayer.stop();
    await _buttonPlayer.play(AssetSource('bgm/bottan.mp3'));
  }

  Future<void> playClearSound() async {
    if (!_initialized) {
      await initialize();
    }
    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource('bgm/clear.mp3'));
  }

  Future<void> playWrongSound() async {
    if (!_initialized) {
      await initialize();
    }
    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource('bgm/wrong.mp3'));
  }

  Future<void> playCheerSound() async {
    if (!_initialized) {
      await initialize();
    }
    await _cheerPlayer.stop();
    await _cheerPlayer
        .play(AssetSource('bgm/Cheer-Yay01-4(High-Applause).mp3'));
  }

  Future<void> playLeverSound() async {
    if (!_initialized) {
      await initialize();
    }
    await _leverPlayer.stop();
    await _leverPlayer.play(AssetSource('bgm/lever.mp3'));
  }

  Future<void> playChallengeSound() async {
    if (!_initialized) {
      await initialize();
    }
    await _challengePlayer.stop();
    await _challengePlayer.play(AssetSource('bgm/challenge.mp3'));
  }

  Future<void> playWhistleSound() async {
    if (!_initialized) {
      await initialize();
    }
    await _whistlePlayer.stop();
    await _whistlePlayer
        .play(AssetSource('bgm/Motion-Falling_Whistle01-3(Short).mp3'));
  }

  Future<void> playFallBoxSound() async {
    if (!_initialized) {
      await initialize();
    }
    await _fallBoxPlayer.stop();
    await _fallBoxPlayer.play(AssetSource('bgm/fallbox.mp3'));
  }

  Future<void> playCharacterPopSound() async {
    if (!_initialized) {
      await initialize();
    }
    await _characterChangePlayer.stop();
    await _characterChangePlayer
        .play(AssetSource('bgm/Onoma-Pop04-1(High-Dry).mp3'));
  }

  Future<void> playQuizBgm() async {
    if (!_initialized) {
      await initialize();
    }
    if (_currentBgmAsset == 'bgm/quiz.mp3') {
      return;
    }
    await _playBgm('bgm/quiz.mp3');
  }

  Future<void> playMainBgm() async {
    if (!_initialized) {
      await initialize();
    }
    if (_currentBgmAsset == 'bgm/BGM.mp3') {
      return;
    }
    await _playBgm('bgm/BGM.mp3');
  }

  Future<void> _playBgm(String asset) async {
    _currentBgmAsset = asset;
    await _bgmPlayer.stop();
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource(asset));
    if (_muted) {
      await _bgmPlayer.setVolume(0);
    } else {
      await _bgmPlayer.setVolume(0.5);
    }
  }

  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _buttonPlayer.dispose();
    await _effectPlayer.dispose();
    await _cheerPlayer.dispose();
    await _leverPlayer.dispose();
    await _challengePlayer.dispose();
    await _whistlePlayer.dispose();
    await _fallBoxPlayer.dispose();
    await _characterChangePlayer.dispose();
    _initialized = false;
  }

  bool get isMuted => _muted;

  Future<void> setMuted(bool muted) async {
    _muted = muted;
    final double volume = muted ? 0 : 0.5;
    await _bgmPlayer.setVolume(volume);
    await _buttonPlayer.setVolume(muted ? 0 : 0.2);
    await _effectPlayer.setVolume(muted ? 0 : 0.5);
    await _cheerPlayer.setVolume(muted ? 0 : 0.35);
    await _leverPlayer.setVolume(muted ? 0 : 0.4);
    await _challengePlayer.setVolume(muted ? 0 : 0.4);
    await _whistlePlayer.setVolume(muted ? 0 : 0.4);
    await _fallBoxPlayer.setVolume(muted ? 0 : 0.5);
    await _characterChangePlayer.setVolume(muted ? 0 : 0.6);
  }
}
