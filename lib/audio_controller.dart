import 'package:audioplayers/audioplayers.dart';

class AudioController {
  static final AudioController _instance = AudioController._internal(); // Ensure that there is only one track played
  factory AudioController() => _instance;
  AudioController._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 1.0;

  Future<void> play() async {
    if (!_isPlaying) {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Infinite loop
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.play(
        AssetSource('sounds/Star_Wars_Main_Theme_Song.mp3'),
      );
      _isPlaying = true;
    }
  }

  void pause() {
    _audioPlayer.pause();
    _isPlaying = false;
  }

  void resume() {
    _audioPlayer.resume();
    _isPlaying = true;
  }

  void setVolume(double volume) {
    _volume = volume;
    _audioPlayer.setVolume(volume);
  }

  bool get isPlaying => _isPlaying;
  double get volume => _volume;
}
