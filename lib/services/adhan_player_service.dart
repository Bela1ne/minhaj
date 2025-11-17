import 'package:audioplayers/audioplayers.dart';

class AdhanPlayerService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playAdhan() async {
    await _player.play(AssetSource('audio/adhan.mp3'));
  }

  static Future<void> stopAdhan() async {
    await _player.stop();
  }

  static bool get isPlaying => _player.state == PlayerState.playing;
}
