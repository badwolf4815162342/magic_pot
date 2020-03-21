import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/object.dart';

import 'package:audioplayers/audio_cache.dart';

class UserModel extends ChangeNotifier {
  static var _animals = new List<Animal>();
  static var _objects = new List<Object>();
  static var _levels = new List<Level>();
  static var _archievements = new List<Difficulty>();
  static var _playerQueue = new List<String>();
  static var _unlockedWith = new List<String>();

  UserModel() {
    _currentAnimal = null;
    _animals.add(new Animal(1, 'Katze', 'assets/pics/katze.png', 'audio/cat.mp3'));
    _animals.add(new Animal(2, 'Eule', 'assets/pics/eule.png', 'audio/cat.mp3'));
    _animals.add(new Animal(3, 'Frosch', 'assets/pics/frosch.png', 'audio/cat.mp3'));
    _animals.add(new Animal(4, 'Einhorn', 'assets/pics/einhorn.png', 'audio/cat.mp3'));
    _animals.add(new Animal(5, 'Fledermaus', 'assets/pics/fledermaus.png', 'audio/cat.mp3'));

    _objects.add(new Object(1, 'hut', WordLevel.ONE, '🎩'));
    //_objects.add(new Object(2, 'eis', WordLevel.ONE, '🍦'));
    _objects.add(new Object(3, 'uhr', WordLevel.ONE, '🕐'));
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

    // Levelnumber minObjects rightObjectsInARow d w ObjectsToChooseFrom
    _levels.add(
        new Level(1, 5, 2, Difficulty.EASY, WordLevel.ONE, 2, 'audio/level_1_explanation.wav'));
    _levels.add(new Level(2, 5, 2, Difficulty.EASY, WordLevel.ONE, 3, 'audio/level_2_explanation.wav'));
    _levels.add(new Level(3, 5, 2, Difficulty.EASY, WordLevel.ONE, 3, 'audio/level_3_explanation.wav'));
    _levels.add(new Level(4, 5, 2, Difficulty.EASY, WordLevel.ONE, 3, 'audio/level_4_explanation.wav'));

    _levels.add(new Level(
        1, 5, 2, Difficulty.MIDDLE, WordLevel.ONE, 2, 'audio/level_1_explanation.mp3'));
    _levels.add(new Level(
        2, 5, 2, Difficulty.MIDDLE, WordLevel.ONE, 2, 'audio/level_2_explanation.mp3'));
    _levels.add(new Level(
        3, 5, 2, Difficulty.MIDDLE, WordLevel.ONE, 2, 'audio/level_3_explanation.mp3'));
    _levels.add(new Level(
        4, 5, 2, Difficulty.MIDDLE, WordLevel.ONE, 2, 'audio/level_4_explanation.mp3'));

    _levels.add(
        new Level(1, 5, 2, Difficulty.HARD, WordLevel.ONE, 2, 'audio/level_1_explanation.mp3'));
    _levels.add(
        new Level(2, 5, 2, Difficulty.HARD, WordLevel.ONE, 2, 'audio/level_2_explanation.mp3'));
    _levels.add(
        new Level(3, 5, 2, Difficulty.HARD, WordLevel.ONE, 2, 'audio/level_3_explanation.mp3'));
    _levels.add(
        new Level(4, 5, 2, Difficulty.HARD, WordLevel.ONE, 2, 'audio/level_4_explanation.mp3'));

    _currentLevelCounter = 1;
    _currentDifficulty = Difficulty.EASY;
    AudioPlayer.logEnabled = false;
  }

  bool _firstAppStart;
  bool _lockScreen = false;

  int _currentLevelCounter;
  Difficulty _currentDifficulty;

  Animal _currentAnimal;

  /// Construct a CartModel instance that is backed by a [CatalogModel] and
  /// an optional previous state of the cart.
  ///
  /// If [previous] is not `null`, it's items are copied to the newly
  /// constructed instance.

  List<Animal> get animals => _animals.toList();

  List<Object> get objects => _objects.toList();

  bool get lockScreen => _lockScreen;

  Difficulty get currentDifficulty => _currentDifficulty;

  Animal get currentAnimal => _currentAnimal;
  int get currentLevelCounter => _currentLevelCounter;
  String get witchIcon => _witchIcon;


  String _witchText = 'audio/cat.mp3';
  String _savedTexsts;

  static AudioPlayer advancedPlayer = new AudioPlayer();
  static AudioCache audioCache = new AudioCache(fixedPlayer: advancedPlayer);

  String _witchIcon = 'assets/pics/witch_pink_smile.png';

  void levelFinished(){
    makeSound('audio/end1.wav');
  }

  /// Change Animal
  void changeAnimal(Animal animal) {
    print('locked' + (_lockScreen ? 'true' : 'false'));
    print(animal.name);
    print(_animals.length);
    if (!(_currentAnimal == null)) {
      _animals.add(_currentAnimal);
    }
    print(_animals.length);
    _currentAnimal = animal;
    _animals.remove(animal);
    print(animal.soundfile);

    makeSound(animal.soundfile);

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  resetToMenu() {
    _currentLevelCounter = 1;
    _currentDifficulty = Difficulty.EASY;
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    advancedPlayer.stop();
    notifyListeners();
  }

  setDifficulty(Difficulty difficulty){
    _currentDifficulty = difficulty;
    notifyListeners();
  }

  void makeSound(String fileName) {
    print('ERROR-----------------------------------------------?');
    print(_playerQueue);
    print(_playerQueue.contains(fileName));
    if (_playerQueue.contains('audio/intro.wav')) {
        print("intro in queue");
    }
    if (_lockScreen && !_playerQueue.contains(fileName)) {
      _savedTexsts = fileName;
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
    print('lock');
    notifyListeners();
  }

  void unlockScreen(String fileName) {
    if (!_unlockedWith.contains(fileName)) {
      print("onluck twice");
      return;
    }
    _unlockedWith.remove(fileName);
    _lockScreen = false;
    _witchIcon = 'assets/pics/witch_pink_smile.png';
    print('unlock');
    notifyListeners();
    audioCache.clear(fileName);
    if (_playerQueue.length>0) {
      String sound = _playerQueue.removeLast();
      // _savedTexsts = null;
      makeSound(sound);
    }
    // wair for two secs
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (_unlockedWith.length>0){
        _lockScreen = false;
      }
      print("-------------------------remove");
      print([]);
    }); 
  }

  void setWitchText(String fileName){
    _witchText = fileName;
  }

  void playWitchText() {
    makeSound(_witchText);
  }

  void praise() {
    var random = new Random();
    var number = 1 + random.nextInt(5);
    makeSound('audio/praise${number}.wav');
  }

  void motivation() {
    var random = new Random();
    var number = 1 + random.nextInt(7);
    makeSound('audio/motivation${number}.wav');
  }

  void explainCurrentLevel() {
    Level level = getLevelFromNumberAndDiff();
    makeSound(level.soundfile);
  }

  void levelUp() {
    _currentLevelCounter += 1;
    print("New Level: ${_currentLevelCounter}.wav");

    if (getLevelFromNumberAndDiff() == null) {
      print("archievement");
      // save archievemnts for menu view
      _archievements.add(Difficulty.EASY);
    }

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void resetAll(){

  }

  Level getLevelFromNumberAndDiff() {
    Level level = _levels.firstWhere(
        (o) => (o.difficulty == _currentDifficulty &&
            o.number == _currentLevelCounter),
        orElse: () => null);
    print("Start Level with ${LevelHelper.printLevelInfo(level)}");
    return level;
  }
}
