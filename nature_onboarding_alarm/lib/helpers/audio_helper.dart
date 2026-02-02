import 'package:audioplayers/audioplayers.dart';

class AudioHelper {
  static final AudioPlayer _player = AudioPlayer();
  static bool _started = false;

  static Future<void> startBgm() async {
    if (_started) return;
    _started = true;

    await _player.setReleaseMode(ReleaseMode.loop);

    await _player.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: false,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gain,
        ),
      ),
    );

    await _player.setVolume(1.0);

    await _player.play(AssetSource("audios/background_ongoing.mp3"));
  }

  static Future<void> stopBgm() async {
    _started = false;
    await _player.stop();
  }
}
