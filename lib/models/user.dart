import 'package:flutter/foundation.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/object.dart';

class UserModel extends ChangeNotifier {
  static var _animals = new List<Animal>();
  static var _objects = new List<Object>();
  static var _levels = new List<Level>();
  static var _archievements = new List<Difficulty>();

  UserModel() {
    _currentAnimal = null;
    _animals.add(new Animal(1, 'Cat', '🐱', 'audio/cat.mp3'));
    _animals.add(new Animal(2, 'Unicorn', '🦄', 'audio/cat.mp3'));
    _animals.add(new Animal(3, 'Raven', '🐦', 'audio/cat.mp3'));
    _animals.add(new Animal(4, 'Frog', '🐸', 'audio/cat.mp3'));
    _animals.add(new Animal(5, 'Raupe', '🐛', 'audio/cat.mp3'));

    _objects.add(new Object(1, 'hut', WordLevel.ONE, '🎩'));
    _objects.add(new Object(2, 'eis', WordLevel.ONE, '🍦'));
    _objects.add(new Object(3, 'uhr', WordLevel.ONE, '🕐'));
    _objects.add(new Object(4, 'maus', WordLevel.ONE, '🐭'));
    _objects.add(new Object(5, 'bär', WordLevel.ONE, '🐻'));
    _objects.add(new Object(6, 'fuss', WordLevel.ONE, '🦶🏻'));
    _objects.add(new Object(7, 'eule', WordLevel.ONE, '🦉'));
    _objects.add(new Object(8, 'kamm', WordLevel.ONE, 'Kamm'));
    _objects.add(new Object(9, 'baum', WordLevel.ONE, '🌳'));
    _objects.add(new Object(10, 'haus', WordLevel.ONE, '🏠'));
    _objects.add(new Object(11, 'tür', WordLevel.ONE, '🚪'));
    _objects.add(new Object(12, 'laus', WordLevel.ONE, 'Laus'));
    _objects.add(new Object(13, 'sieb', WordLevel.ONE, 'Sieb'));
    _objects.add(new Object(14, 'hof', WordLevel.ONE, 'Hof'));
    _objects.add(new Object(15, 'ohr', WordLevel.ONE, '👂🏻'));
    _objects.add(new Object(16, 'boot', WordLevel.ONE, '⛵️'));
    _objects.add(new Object(17, 'ring', WordLevel.ONE, '💍'));
    _objects.add(new Object(18, 'stroh', WordLevel.ONE, 'Stroh'));
    _objects.add(new Object(19, 'buch', WordLevel.ONE, '📕'));
    _objects.add(new Object(20, 'mann', WordLevel.ONE, '🤵🏻'));
    _objects.add(new Object(21, 'stuhl', WordLevel.ONE, 'Stuhl'));
    _objects.add(new Object(22, 'tisch', WordLevel.ONE, 'Tisch'));
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
        new Level(1, 5, 2, Difficulty.EASY, WordLevel.ONE, 2, 'audio/cat.mp3'));
    //_levels.add(new Level(2, 5, 2, Difficulty.EASY, WordLevel.ONE, 2));
    //_levels.add(new Level(3, 5, 2, Difficulty.EASY, WordLevel.ONE, 2));
    //_levels.add(new Level(4, 5, 2, Difficulty.EASY, WordLevel.ONE, 2));

    _levels.add(new Level(
        1, 5, 2, Difficulty.MIDDLE, WordLevel.ONE, 2, 'audio/cat.mp3'));
    _levels.add(new Level(
        2, 5, 2, Difficulty.MIDDLE, WordLevel.ONE, 2, 'audio/cat.mp3'));
    _levels.add(new Level(
        3, 5, 2, Difficulty.MIDDLE, WordLevel.ONE, 2, 'audio/cat.mp3'));
    _levels.add(new Level(
        4, 5, 2, Difficulty.MIDDLE, WordLevel.ONE, 2, 'audio/cat.mp3'));

    _levels.add(
        new Level(1, 5, 2, Difficulty.HARD, WordLevel.ONE, 2, 'audio/cat.mp3'));
    _levels.add(
        new Level(2, 5, 2, Difficulty.HARD, WordLevel.ONE, 2, 'audio/cat.mp3'));
    _levels.add(
        new Level(3, 5, 2, Difficulty.HARD, WordLevel.ONE, 2, 'audio/cat.mp3'));
    _levels.add(
        new Level(4, 5, 2, Difficulty.HARD, WordLevel.ONE, 2, 'audio/cat.mp3'));

    _currentLevelCounter = 1;
    _currentDifficulty = Difficulty.EASY;
  }

  bool _firstAppStart;

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

  Animal get currentAnimal => _currentAnimal;
  int get currentLevelCounter => _currentLevelCounter;

  /// Change Animal
  void changeAnimal(Animal animal) {
    print(animal.name);
    print(_animals.length);
    if (!(_currentAnimal == null)) {
      _animals.add(_currentAnimal);
    }
    print(_animals.length);
    _currentAnimal = animal;
    _animals.remove(animal);
    print(_animals.length);

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void levelUp() {
    _currentLevelCounter += 1;
    print("New Level: ${_currentLevelCounter}");

    if (getLevelFromNumberAndDiff() == null) {
      print("archievement");
      // save archievemnts for menu view
      _archievements.add(Difficulty.EASY);
    }

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
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
