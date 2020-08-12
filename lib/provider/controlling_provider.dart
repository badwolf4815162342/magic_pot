import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/level.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:magic_pot/provider/db_provider.dart';

import '../logger.util.dart';

class ControllingProvider extends ChangeNotifier {
  final log = getLogger();
  static var _animals = new List<Animal>();
  static var _playerQueue = new List<String>();
  static var _unlockedWith = new List<String>();

  ControllingProvider() {
    _currentAnimal = null;
    _setCurrentAnimal();
    _setCurrentLevelStart();
    AudioPlayer.logEnabled = false;
  }

  _setCurrentAnimal() async {
    if (_currentAnimal == null) {
      _animals = await DBProvider.db.getAllAnimals();
      _currentAnimal =
          _animals.firstWhere((o) => (o.isCurrent), orElse: () => null);
      notifyListeners();
    }
    return _currentAnimal;
  }

  _setCurrentLevelStart() async {
    if (_currentLevel == null) {
      _currentLevelCounter = 1;
      _currentLevel = await getLevelFromId();
    }
  }

  bool _lockScreen = false;
  bool _allArchieved = false;

  bool blinkingPlayButton = false;

  int _currentLevelCounter;

  Animal _currentAnimal;
  Level _currentLevel;

  List<Animal> get animals => _animals.toList();

  bool get lockScreen => _lockScreen;
  bool get allArchieved => _allArchieved;

  Animal get currentAnimal => _currentAnimal;

  Level get currentLevel => _currentLevel;

  String get witchIcon => _witchIcon;

  String _witchIcon = GlobalConfiguration().getString("standart_witch_icon");
  String _witchText = GlobalConfiguration().getString("standart_witch_text");

  /// Change Animal
  void changeAnimal(Animal animal) {
    log.d('ControllingProvider:' +
        'Screen locked' +
        (_lockScreen ? 'true' : 'false'));
    log.d('ControllingProvider:' +
        'Animal ' +
        animal.name +
        'Sound ' +
        animal.soundfile);
    log.d(
        'ControllingProvider:' + 'Anima-length ' + _animals.length.toString());
    var oldAnimal = _currentAnimal;
    log.d('ControllingProvider:' +
        'Anima-length (after add) ' +
        _animals.length.toString());
    _currentAnimal = animal;

    Future.delayed(const Duration(seconds: 2), () {
      //log.e('CHANGE: new removed ' +
      //    animal.name +
      //    ' old added ' +
      //    oldAnimal.name);
      //log.e('ControllingProvider: Animals: ' + _animals.map((e) => e.name).join(','));
      _animals.remove(animal);
      if (!(oldAnimal == null)) {
        _animals.add(oldAnimal);
      }
      saveCurrentAnimal();
    });

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  saveCurrentAnimal() async {
    int i = await DBProvider.db.updateCurrentAnimal(_currentAnimal, _animals);
    log.e('ControllingProvider: Save current Animal: ' + i.toString());
  }

  resetToMenu() {
    setPlayAtNewestPosition();
    _witchText = GlobalConfiguration().getString("standart_witch_text");
    stopAllSound();
    notifyListeners();
  }

  setAllArchieved() async {
    bool allArchieved = await DBProvider.db.allArchieved();
    _allArchieved = allArchieved;
    notifyListeners();
  }

  setPlayAtNewestPosition() async {
    Level level = await DBProvider.db.getHighestLevel();
    if (level == null) {
      _currentLevelCounter = 1;
      _currentLevel = await getLevelFromId();
    } else {
      log.i('ControllingProvider: HIghest Level = ' +
          level.number.toString() +
          ' ' +
          level.difficulty.toString());
      setLevel(level);
    }
  }

  Future<void> levelUp() async {
    if (_currentLevel.number == 1) {
      _currentLevel.achievement = true;
      await DBProvider.db.updateLevel(_currentLevel);
    }
    if (_currentLevel.id != 15) {
      _currentLevelCounter += 1;
      _currentLevel = await getLevelFromId();
      _currentLevel.achievement = true;
      await DBProvider.db.updateLevel(_currentLevel);
    }

    if (_currentLevel.finalLevel) {
      setAllArchieved();
    }

    log.i('ControllingProvider:' +
        'New Level: ${_currentLevelCounter}.wav (levelUp)');

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  Future<void> setLevelAnimatedFalse() async {
    await DBProvider.db.updateLevelNotAnimated();
  }

  void setLevel(Level level) {
    _currentLevel = level;
    _currentLevelCounter = level.id;
    _witchText = GlobalConfiguration().getString("standart_witch_text");
    log.i('ControllingProvider:' +
        'Change level to ${LevelHelper.printLevelInfo(level)} (setLevel)');
  }

  void resetAll() {}

  Future<Level> getLevelFromId() async {
    Level level = await DBProvider.db.getLevelById(_currentLevelCounter);
    log.i('ControllingProvider:' +
        'Start Level with ${LevelHelper.printLevelInfo(level)} (levelUp)');
    return level;
  }
  // AUDIO PLAYER STUFF

  static AudioPlayer advancedPlayer = new AudioPlayer();
  static AudioCache audioCache = new AudioCache(fixedPlayer: advancedPlayer);

  void updateWitchText(String newWitchText) {
    _witchText = newWitchText;
  }

  Future<void> explainCurrentLevel() async {
    updateWitchText(_currentLevel.soundfile);
    makeSound(_currentLevel.soundfile);
  }

  void explainAcceptedObject(String acceptedObjectText) {
    makeSound(acceptedObjectText);
  }

  void tellStandartWitchText() {
    var random = new Random();
    var number = 1 + random.nextInt(6);
    makeSound('audio/witch_random_${number}.wav');
  }

  Future<void> tellLevelFinished() async {
    List<Level> levels = await DBProvider.db.getLevelByArchieved();
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
    makeSound('audio/effect_transition.wav');
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
    String intro = GlobalConfiguration().getString("witch_intro");
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
      makeSound('audio/witch_praise${number}.wav');
    }
  }

  void reset_ingr() {
    var random = new Random();
    var number = 1 + random.nextInt(4);
    makeSound('audio/witch_reset_ingr_${number}.wav');
  }

  void motivation() {
    var random = new Random();
    var number = 1 + random.nextInt(6);
    makeSound('audio/effect_error_2.wav');
    makeSound('audio/witch_motivation_${number}.wav');
  }

  Future myLoadAsset(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (_) {
      return null;
    }
  }

  Future<void> makeSound(String fileName) async {
    var witch = false;

    log.d('ControllingProvider:' +
        'Player-Queue ' +
        _playerQueue.toString() +
        ' contains ' +
        fileName +
        ' ? ' +
        _playerQueue.contains(fileName).toString());

    if (_playerQueue.contains('audio/intro.wav')) {
      log.e('ControllingProvider:' + 'Player-Queue contains audio/intro.wav');
    }

    if (_lockScreen && !_playerQueue.contains(fileName)) {
      //_savedTexsts = fileName;
      log.e('ControllingProvider: Put ' +
          fileName +
          ' filename in playerqueeu (makesound)');
      _playerQueue.add(fileName);
      return;
    }
    if (fileName.startsWith('audio/witch')) {
      witch = true;
    }
    verlockScreen(fileName, witch);
    log.e(audioCache.toString());

// TEST create new audiocache
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    audioCache.play(fileName);
    advancedPlayer.onPlayerCompletion.listen((event) {
      log.d('ControllingProvider: Oncompletion ' + fileName);
      if (!_unlockedWith.contains(fileName)) {
        log.e('ControllingProvider:' +
            'Already unlocked with ' +
            fileName +
            ' - not in unlockedWith(unlockScreen)');
        audioCache.clear(fileName);
      } else {
        unlockScreen(fileName, witch);
      }
    });
  }

  // LOCKING SCREEN

  void verlockScreen(String fileName, bool witch) {
    _lockScreen = true;
    // Filename to unlock later
    _unlockedWith.add(fileName);
    if (witch) {
      _witchIcon = GlobalConfiguration().getString("talking_witch_icon");
    }
    log.e('ControllingProvider:' + 'lock screen (verlockScreen)');
    notifyListeners();
  }

  void unlockScreen(String fileName, bool witch) {
    _unlockedWith.remove(fileName);
    _lockScreen = false;
    if (witch) {
      _witchIcon = 'assets/pics/witch_pink_smile.png';
    }
    log.i('ControllingProvider:' +
        'unlocking screen with ' +
        fileName +
        ' (unlockScreen)');
    notifyListeners();
    audioCache.clear(fileName);
    if (_playerQueue.length > 0) {
      log.i('ControllingProvider:' +
          'more in queue ' +
          _playerQueue.toString() +
          ' (unlockScreen)');
      String sound = _playerQueue.removeLast();
      // _savedTexsts = null;
      makeSound(sound);
    }
    /* wait for two secs **
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_unlockedWith.length > 0 && ) {
        _lockScreen = false;
      }
      log.e('ControllingProvider:' + '-------------------------remove???(unlockScreen)');
    });*/
  }

  // RESET ALL SOUND ACTION
  void stopAllSound() {
    audioCache.clearCache();
    _playerQueue = new List<String>();
    advancedPlayer.stop();
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    _witchIcon = 'assets/pics/witch_pink_smile.png';
    _lockScreen = false;
    notifyListeners();
  }

  Future<void> menuSound(bool newArchievements) async {
    if (newArchievements) {
      makeSound('audio/effect_pring.wav');
    }
    Future.delayed(const Duration(milliseconds: 1000), () async {
      List<Level> levels = await DBProvider.db.getLevelByArchieved();
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
