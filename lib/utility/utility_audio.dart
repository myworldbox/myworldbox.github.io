import 'package:audioplayers/audioplayers.dart';

class UtilityAudio {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> start(String path) async {
    // Start playing music automatically
    await _audioPlayer.play(AssetSource(path), volume: 1.0);
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }
}
