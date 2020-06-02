/**import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:magic_pot/logger.util.dart';

class AudioModel extends ChangeNotifier {
  final log = getLogger();

  static var _playerQueue = new List<String>();
  static var _unlockedWith = new List<String>();

  String get witchIcon => _witchIcon;

  String _witchIcon = GlobalConfiguration().getString("standart_witch_icon");

  String _witchText = GlobalConfiguration().getString("standart_witch_text");

  bool _lockScreen = false;

  bool get lockScreen => _lockScreen;

  static AudioPlayer advancedPlayer = new AudioPlayer();
  static AudioCache audioCache = new AudioCache(fixedPlayer: advancedPlayer);

  AudioModel() {
    AudioPlayer.logEnabled = false;
  }

  resetAudio() {
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    advancedPlayer.stop();

    audioCache.clearCache();
    _playerQueue = new List<String>();
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
  }

  void makeSound(String fileName) {
    log.d('UserModel:' +
        'Player-Queue ' +
        _playerQueue.toString() +
        ' contains ' +
        fileName +
        ' ? ' +
        _playerQueue.contains(fileName).toString());

    if (_playerQueue.contains('audio/intro.wav')) {
      log.e('UserModel:' + 'Player-Queue contains audio/intro.wav');
    }
    if (_lockScreen && !_playerQueue.contains(fileName)) {
      _playerQueue.add(fileName);
      return;
    }
    verlockScreen(fileName);
    audioCache.play(fileName);
    advancedPlayer.onPlayerCompletion.listen((event) {
      unlockScreen(fileName);
    });
  }

  void verlockScreen(String fileName) {
    _lockScreen = true;
    _unlockedWith.add(fileName);
    _witchIcon = 'assets/pics/witch_pink_oh.png';
    log.e('UserModel:' + 'lock screen (verlockScreen)');
    notifyListeners();
  }

  void unlockScreen(String fileName) {
    if (!_unlockedWith.contains(fileName)) {
      log.e('UserModel:' + 'unlock unlocked screen (unlockScreen)');
      return;
    }
    _unlockedWith.remove(fileName);
    _lockScreen = false;
    _witchIcon = 'assets/pics/witch_pink_smile.png';
    log.i('UserModel:' + 'unlock screen (unlockScreen)');
    notifyListeners();
    audioCache.clear(fileName);
    if (_playerQueue.length > 0) {
      String sound = _playerQueue.removeLast();
      // _savedTexsts = null;
      makeSound(sound);
    }
    // wair for two secs
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_unlockedWith.length > 0) {
        _lockScreen = false;
      }
      log.e('UserModel:' + '-------------------------remove???(unlockScreen)');
    });
  }

  void setWitchText(String fileName) {
    _witchText = fileName;
  }

  void letWitchTalk() {
    makeSound(_witchText);
  }
}
**/
