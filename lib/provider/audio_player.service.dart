import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/util/constant.util.dart';

import '../util/logger.util.dart';

// Singleton class two hold the states lockScreen, witchTalking and stayBright (objects should not be darkened (DarknableImage) when sound is played) over the whole application
class AudioPlayerService extends ChangeNotifier {
  final log = getLogger();

  factory AudioPlayerService() {
    return _singleton;
  }

  AudioPlayerService._internal({init()});

  static final AudioPlayerService _singleton = AudioPlayerService._internal();

  bool _isInitializing = true;
  bool get isIntializing => _isInitializing;

  static AudioPlayer advancedPlayer;
  static AudioCache audioCache;

  // Holds list of audio files that should be playerd while one is already playing
  static var _playerQueue = new List<String>();

  // Secures that in case of one call back returns twice we do only one screen unlocking
  static var _unlockedWith = new List<String>();

  // STATES
  static String _witchText = Constant.standartWitchTextPath;

  bool _witchTalking = false;
  bool _lockScreen = false;
  bool _stayBright = false;

  bool get witchTalking => _witchTalking;
  bool get lockScreen => _lockScreen;
  bool get stayBright => _stayBright;

  Future init() async {
    _isInitializing = false;
    notifyListeners();
  }

  // Stop All sound and reset witchText to standart menu text
  resetAudioPlayerToMenu() {
    updateWitchText(Constant.standartWitchTextPath);
    stopAllSound();
    notifyListeners();
  }

  void updateWitchText(String newWitchText) {
    _witchText = newWitchText;
  }

  Future<void> explainCurrentLevel(Level currentLevel) async {
    updateWitchText(currentLevel.soundfile);
    makeSound(currentLevel.soundfile);
  }

  void explainAcceptedObject(String acceptedObjectText) {
    updateWitchText(acceptedObjectText);
    makeSound(acceptedObjectText);
  }

  void tellStandartWitchText() {
    var random = new Random();
    var number = 1 + random.nextInt(6);
    makeSound('audio/witch_random_$number.wav');
  }

  Future<void> tellLevelFinished() async {
    List<Level> levels = await DBApi.db.getLevelByAchieved();
    // Diffrent text when all archievements are archieved
    if (levels.length == 15) {
      makeSound('audio/witch_end_3.wav');
    } else {
      makeSound('audio/witch_end1.wav');
    }
  }

  void makeAnimalSound(String file) {
    makeSound(file);
  }

  void tellChooseAnimal() {
    makeSound('audio/witch_waehle_dein_tier.wav');
  }

  void transitionSound() {
    makeSound('audio/long_effect_transition.wav');
  }

  void quitButtonText(bool close) {
    if (close) {
      makeSound('audio/witch_quit_close.wav');
    } else {
      makeSound('audio/witch_quit_to_menu.wav');
    }
  }

  void archievementButtonText(bool finalLevel) {
    if (finalLevel) {
      makeSound('audio/witch_archievement_question_final.wav');
    } else {
      makeSound('audio/witch_archievement_question.wav');
    }
  }

  void setWitchText(String fileName) {
    _witchText = fileName;
  }

  void tellIntroduction() {
    String intro = Constant.introWitchTextPath;
    makeSound(intro);
  }

  void playWitchText() {
    makeSound(_witchText);
  }

  void praise(bool speak) {
    var random = new Random();
    var number = 1 + random.nextInt(10);
    makeSound('audio/effect_pring.wav');
    if (speak) {
      makeSound('audio/witch_praise$number.wav');
    }
  }

  void pring() {
    makeSound('audio/effect_pring.wav');
  }

  void error() {
    makeSound('audio/effect_error_2.wav');
  }

  void resetIngredient() {
    var random = new Random();
    var number = 1 + random.nextInt(4);
    makeSound('audio/witch_reset_ingr_$number.wav');
  }

  void motivation() {
    var random = new Random();
    var number = 1 + random.nextInt(6);
    makeSound('audio/effect_error_2.wav');
    makeSound('audio/witch_motivation_$number.wav');
  }

  Future<void> makeSound(String fileName) async {
    var witch = false;

    log.d('AudioPlayerService:' +
        'Player-Queue ' +
        _playerQueue.toString() +
        ' contains ' +
        fileName +
        ' ? ' +
        _playerQueue.contains(fileName).toString());

    if (_playerQueue.contains('audio/intro.wav')) {
      log.e('AudioPlayerService:' + 'Player-Queue contains audio/intro.wav');
    }
    if (_lockScreen && !_playerQueue.contains(fileName)) {
      log.e('AudioPlayerService: Put ' + fileName + ' filename in playerqueeu (makesound)');
      _playerQueue.add(fileName);
      return;
    }
    if (fileName.startsWith('audio/witch')) {
      witch = true;
    }
    verlockScreen(fileName, witch);
    log.e(audioCache.toString());

    // create new audiocache and player for each audiofile to ensure deleting of old ones
    // all files are played one after the other
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    audioCache.play(fileName);
    advancedPlayer.onPlayerCompletion.listen((event) {
      log.d('ControllingProvider: Oncompletion ' + fileName);
      // Do not unlock twice
      if (!_unlockedWith.contains(fileName)) {
        log.e('ControllingProvider:' + 'Already unlocked with ' + fileName + ' - not in unlockedWith(unlockScreen)');
        audioCache.clear(fileName);
      } else {
        unlockScreen(fileName, witch);
      }
    });
  }

  // LOCKING SCREEN
  void verlockScreen(String fileName, bool witch) {
    if (fileName.contains('long')) {
      log.d('transformation');
    }
    if (!fileName.contains('witch') && !fileName.contains('long')) {
      _stayBright = true;
    }
    _lockScreen = true;
    // Filename to unlock later
    _unlockedWith.add(fileName);
    if (witch) {
      _witchTalking = true;
    }
    log.e('ControllingProvider:' + 'lock screen (verlockScreen)');
    notifyListeners();
  }

  void unlockScreen(String fileName, bool witch) {
    _unlockedWith.remove(fileName);
    _lockScreen = false;
    // longer audiofiles should make the screen dark (show that no interaction is possible), shorter files (do not contain witch or long) let the rest stay bright (even if uncklickable)
    if (!fileName.contains('witch') && !fileName.contains('long')) {
      _stayBright = false;
    }
    if (witch) {
      _witchTalking = false;
    }
    log.i('ControllingProvider:' + 'unlocking screen with ' + fileName + ' (unlockScreen)');
    notifyListeners();
    audioCache.clear(fileName);
    if (_playerQueue.length > 0) {
      log.i('ControllingProvider:' + 'more in queue ' + _playerQueue.toString() + ' (unlockScreen)');
      String sound = _playerQueue.removeLast();
      makeSound(sound);
    }
  }

  // RESET ALL SOUND ACTION
  void stopAllSound() {
    audioCache.clearCache();
    _playerQueue = new List<String>();
    advancedPlayer.stop();
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    _witchTalking = false;
    _lockScreen = false;
    notifyListeners();
  }

  Future<void> menuSound() async {
    bool newArchievements = await DBApi.db.newArchievements();

    if (newArchievements) {
      makeSound('audio/effect_pring.wav');
    }
    Future.delayed(const Duration(milliseconds: 2000), () async {
      List<Level> levels = await DBApi.db.getLevelByAchieved();
      if (levels.length == 1) {
        makeSound('audio/witch_menu_explanation_first.wav');
      } else if (levels.length >= 15) {
        makeSound('audio/witch_menu_explanation_final.wav');
      } else {
        makeSound('audio/witch_menu_explanation.wav');
      }
    });
  }
}
