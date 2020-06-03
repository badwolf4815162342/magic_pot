import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/object.dart';

import 'package:audioplayers/audio_cache.dart';

import '../logger.util.dart';

class UserModel extends ChangeNotifier {
  final log = getLogger();
  static var _animals = new List<Animal>();
  static var _objects = new List<Object>();
  static var _levels = new List<Level>();
  static var _archievements = new List<Level>();
  static var _playerQueue = new List<String>();
  static var _unlockedWith = new List<String>();

  UserModel() {
    _currentAnimal = null;
    _animals
        .add(new Animal(1, 'Katze', 'assets/pics/katze.png', 'audio/cat.mp3'));
    _animals
        .add(new Animal(2, 'Eule', 'assets/pics/eule.png', 'audio/owl.wav'));
    _animals.add(
        new Animal(3, 'Frosch', 'assets/pics/frosch.png', 'audio/frog.mp3'));
    _animals.add(new Animal(
        4, 'Einhorn', 'assets/pics/einhorn.png', 'audio/unicorn.mp3'));
    _animals.add(new Animal(
        5, 'Fledermaus', 'assets/pics/fledermaus.png', 'audio/bat.mp3'));

    _objects.add(new Object(1, 'hut', WordLevel.ONE, '🎩'));
    //_objects.add(new Object(2, 'eis', WordLevel.ONE, '🍦'));
    //_objects.add(new Object(3, 'uhr', WordLevel.ONE, '🕐')); ???
    _objects.add(new Object(4, 'maus', WordLevel.ONE, '🐭'));
    _objects.add(new Object(5, 'bär', WordLevel.ONE, '🐻'));
    _objects.add(new Object(6, 'fuss', WordLevel.ONE, '🦶🏻'));
    _objects.add(new Object(7, 'eule', WordLevel.ONE, '🦉'));
    //_objects.add(new Object(8, 'kamm', WordLevel.ONE, 'Kamm'));
    _objects.add(new Object(9, 'baum', WordLevel.ONE, '🌳'));
    _objects.add(new Object(10, 'haus', WordLevel.ONE, '🏠'));
    _objects.add(new Object(11, 'tür', WordLevel.ONE, '🚪'));
    //_objects.add(new Object(12, 'laus', WordLevel.ONE, 'Laus'));
    //_objects.add(new Object(13, 'sieb', WordLevel.ONE, 'Sieb'));
    //_objects.add(new Object(14, 'hof', WordLevel.ONE, 'Hof'));
    _objects.add(new Object(15, 'ohr', WordLevel.ONE, '👂🏻'));
    _objects.add(new Object(16, 'boot', WordLevel.ONE, '⛵️'));
    _objects.add(new Object(17, 'ring', WordLevel.ONE, '💍'));
    //_objects.add(new Object(18, 'stroh', WordLevel.ONE, 'Stroh'));
    _objects.add(new Object(19, 'buch', WordLevel.ONE, '📕'));
    _objects.add(new Object(20, 'mann', WordLevel.ONE, '🤵🏻'));
    //_objects.add(new Object(21, 'stuhl', WordLevel.ONE, 'Stuhl'));
    //_objects.add(new Object(22, 'tisch', WordLevel.ONE, 'Tisch'));
    _objects.add(new Object(23, 'schaf', WordLevel.ONE, '🐑'));
    _objects.add(new Object(24, 'reh', WordLevel.ONE, '🦌'));
    _objects.add(new Object(25, 'fisch', WordLevel.ONE, '🐠'));
    _objects.add(new Object(26, 'frau', WordLevel.ONE, '🙎🏻‍♀️'));
    _objects.add(new Object(27, 'opa', WordLevel.ONE, '👴🏻'));
    _objects.add(new Object(28, 'oma', WordLevel.ONE, '👵🏻'));
    _objects.add(new Object(29, 'klee', WordLevel.ONE, '🍀'));
    _objects.add(new Object(30, 'ball', WordLevel.ONE, '⚽️'));

    _objects.add(new Object(31, 'kuh', WordLevel.ONE, '🐮'));

    // Levelnumber minObjects rightObjectsInARow d w ObjectsToChooseFrom pic
    _levels.add(new Level(
        1,
        5,
        2,
        Difficulty.EASY,
        WordLevel.ONE,
        2,
        'audio/witch_level_1_explanation.wav',
        'assets/pics/mouse.png',
        'assets/pics/mouse.png'));
    _levels.add(new Level(
        2,
        5,
        2,
        Difficulty.EASY,
        WordLevel.ONE,
        3,
        'audio/witch_level_2_explanation.wav',
        'assets/pics/mouse.png',
        'assets/pics/elephantouse-2.png'));
    _levels.add(new Level(
        3,
        5,
        2,
        Difficulty.EASY,
        WordLevel.ONE,
        3,
        'audio/witch_level_3_explanation.wav',
        'assets/pics/elephantouse-2.png',
        'assets/pics/elephantouse-3.png'));
    _levels.add(new Level(
        4,
        5,
        2,
        Difficulty.EASY,
        WordLevel.ONE,
        3,
        'audio/witch_level_4_explanation.wav',
        'assets/pics/elephantouse-3.png',
        'assets/pics/elephantouse-4.png'));

    _levels.add(new Level(
        1,
        5,
        2,
        Difficulty.MIDDLE,
        WordLevel.ONE,
        2,
        'audio/witch_level_1_explanation.mp3',
        'assets/pics/mouse.png',
        'assets/pics/elephantouse-3.png'));
    _levels.add(new Level(
        2,
        5,
        2,
        Difficulty.MIDDLE,
        WordLevel.ONE,
        2,
        'audio/witch_level_2_explanation.mp3',
        'assets/pics/mouse.png',
        'assets/pics/elephantouse-3.png'));
    _levels.add(new Level(
        3,
        5,
        2,
        Difficulty.MIDDLE,
        WordLevel.ONE,
        2,
        'audio/witch_level_3_explanation.mp3',
        'assets/pics/mouse.png',
        'assets/pics/elephantouse-3.png'));
    _levels.add(new Level(
        4,
        5,
        2,
        Difficulty.MIDDLE,
        WordLevel.ONE,
        2,
        'audio/witch_level_4_explanation.mp3',
        'assets/pics/mouse.png',
        'assets/pics/elephantouse-3.png'));

    _levels.add(new Level(
        1,
        5,
        2,
        Difficulty.HARD,
        WordLevel.ONE,
        2,
        'audio/witch_level_1_explanation.mp3',
        'assets/pics/mouse.png',
        'assets/pics/elephantouse-3.png'));
    _levels.add(new Level(
        2,
        5,
        2,
        Difficulty.HARD,
        WordLevel.ONE,
        2,
        'audio/witch_level_2_explanation.mp3',
        'assets/pics/mouse.png',
        'assets/pics/elephantouse-3.png'));
    _levels.add(new Level(
        3,
        5,
        2,
        Difficulty.HARD,
        WordLevel.ONE,
        2,
        'audio/witch_level_3_explanation.mp3',
        'assets/pics/mouse.png',
        'assets/pics/elephantouse-3.png'));
    _levels.add(new Level(
        4,
        5,
        2,
        Difficulty.HARD,
        WordLevel.ONE,
        2,
        'audio/witch_level_4_explanation.mp3',
        'assets/pics/mouse.png',
        'assets/pics/elephantouse-3.png'));

    _currentLevelCounter = 1;
    _currentDifficulty = Difficulty.EASY;
    AudioPlayer.logEnabled = false;
  }

  bool _firstAppStart;
  bool _lockScreen = false;

  bool blinkingPlayButton = false;

  int _currentLevelCounter;
  Difficulty _currentDifficulty;

  Animal _currentAnimal;

  List<Animal> get animals => _animals.toList();

  List<Level> get archievements => _archievements.toList();

  List<Object> get objects => _objects.toList();

  bool get lockScreen => _lockScreen;

  Difficulty get currentDifficulty => _currentDifficulty;

  Animal get currentAnimal => _currentAnimal;
  int get currentLevelCounter => _currentLevelCounter;
  String get witchIcon => _witchIcon;

  String _witchIcon = GlobalConfiguration().getString("standart_witch_icon");
  String _witchText = GlobalConfiguration().getString("standart_witch_text");

  /// Change Animal
  void changeAnimal(Animal animal) {
    log.d('UserModel:' + 'Screen locked' + (_lockScreen ? 'true' : 'false'));
    log.d('UserModel:' + 'Animal ' + animal.name + 'Sound ' + animal.soundfile);
    log.d('UserModel:' + 'Anima-length ' + _animals.length.toString());
    if (!(_currentAnimal == null)) {
      _animals.add(_currentAnimal);
    }
    log.d('UserModel:' +
        'Anima-length (after add) ' +
        _animals.length.toString());
    _currentAnimal = animal;
    _animals.remove(animal);
    makeSound(animal.soundfile);

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  resetToMenu() {
    _currentLevelCounter = 1;
    _currentDifficulty = Difficulty.EASY;
    stopAllSound();
    notifyListeners();
  }

  setDifficulty(Difficulty difficulty) {
    _currentDifficulty = difficulty;
    notifyListeners();
  }

  void levelUp() {
    _archievements.add(getLevelFromNumberAndDiff());
    _currentLevelCounter += 1;
    log.i('UserModel:' + 'New Level: ${_currentLevelCounter}.wav (levelUp)');
    if (getLevelFromNumberAndDiff() == null) {
      log.i('UserModel:' + 'Archievement: Difficulty up (levelUp)');
      // save archievemnts for menu view
      //_archievements.add(Difficulty.EASY);
    }

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void setLevel(Level level) {
    _currentDifficulty = level.difficulty;
    _currentLevelCounter = level.number;
    _witchText = GlobalConfiguration().getString("standart_witch_text");
    log.i('UserModel:' +
        'Change level to ${LevelHelper.printLevelInfo(level)} (setLevel)');
  }

  void resetAll() {}

  Level getLevelFromNumberAndDiff() {
    Level level = _levels.firstWhere(
        (o) => (o.difficulty == _currentDifficulty &&
            o.number == _currentLevelCounter),
        orElse: () => null);
    log.i('UserModel:' +
        'Start Level with ${LevelHelper.printLevelInfo(level)} (levelUp)');
    return level;
  }
  // AUDIO PLAYER STUFF

  static AudioPlayer advancedPlayer = new AudioPlayer();
  static AudioCache audioCache = new AudioCache(fixedPlayer: advancedPlayer);

  void updateWitchText(String newWitchText) {
    _witchText = newWitchText;
  }

  void explainCurrentLevel() {
    Level level = getLevelFromNumberAndDiff();
    makeSound(level.soundfile);
  }

  void explainAcceptedObject(String acceptedObjectText) {
    makeSound(acceptedObjectText);
  }

  void tellLevelFinished() {
    makeSound('audio/witch_end1.wav');
  }

  void tellChooseAnimal() {
    makeSound('audio/witch_waehle_dein_tier.wav');
  }

  void transitionSound() {
    makeSound('audio/effect_transition.mp3');
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

  void praise() {
    var random = new Random();
    var number = 1 + random.nextInt(10);
    makeSound('audio/effect_pring.mp3');
    makeSound('audio/witch_praise${number}.wav');
  }

  void motivation() {
    var random = new Random();
    var number = 1 + random.nextInt(4);
    makeSound('audio/effect_error_2.mp3');
    makeSound('audio/witch_motivation${number}.wav');
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
      //_savedTexsts = fileName;
      log.e('UserModel: Put ' +
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
      log.d('UserModel: Oncompletion ' + fileName);
      if (!_unlockedWith.contains(fileName)) {
        log.e('UserModel:' +
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
    log.e('UserModel:' + 'lock screen (verlockScreen)');
    notifyListeners();
  }

  void unlockScreen(String fileName, bool witch) {
    _unlockedWith.remove(fileName);
    _lockScreen = false;
    if (witch) {
      _witchIcon = 'assets/pics/witch_pink_smile.png';
    }
    log.i(
        'UserModel:' + 'unlocking screen with ' + fileName + ' (unlockScreen)');
    notifyListeners();
    audioCache.clear(fileName);
    if (_playerQueue.length > 0) {
      log.i('UserModel:' +
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
      log.e('UserModel:' + '-------------------------remove???(unlockScreen)');
    });*/
  }

  // RESET ALL SOUND ACTION
  void stopAllSound() {
    audioCache.clearCache();
    _playerQueue = new List<String>();
    advancedPlayer.stop();
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
  }
}
