import 'package:flutter/foundation.dart';
import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/level.dart';

import '../util/logger.util.dart';

// (Singleton) holds states used in the whole game like currentLevel or currentAnimal
class UserStateService extends ChangeNotifier {
  final log = getLogger();

  factory UserStateService() {
    return _singleton;
  }

  UserStateService._internal({init()});

  bool _isInitializing = true;
  bool get isIntializing => _isInitializing;

  static var _animals = new List<Animal>();
  bool _allArchieved = false;
  bool blinkingPlayButton = false;
  int _currentLevelCounter;
  Animal _currentAnimal;
  Level _currentLevel;
  List<Animal> get animals => _animals.toList();
  bool get allArchieved => _allArchieved;

  Animal get currentAnimal => _currentAnimal;
  _setCurrentAnimal() async {
    if (_currentAnimal == null) {
      _animals = await DBApi.db.getAllAnimals();
      _currentAnimal = _animals.firstWhere((o) => (o.isCurrent), orElse: () => null);
      notifyListeners();
    }
    return _currentAnimal;
  }

  Level get currentLevel => _currentLevel;
  _setCurrentLevelStart() async {
    if (_currentLevel == null) {
      _currentLevelCounter = 1;
      _currentLevel = await getLevelFromId();
    }
  }

  static final UserStateService _singleton = UserStateService._internal();

  Future init() async {
    _currentAnimal = null;
    await _setCurrentAnimal();
    await _setCurrentLevelStart();
    _isInitializing = false;
    notifyListeners();
  }

  /// Change Animal
  void changeAnimal(Animal animal) {
    log.d('ControllingProvider:' + 'Animal ' + animal.name + 'Sound ' + animal.soundfile);
    log.d('ControllingProvider:' + 'Anima-length ' + _animals.length.toString());
    var oldAnimal = _currentAnimal;
    log.d('ControllingProvider:' + 'Anima-length (after add) ' + _animals.length.toString());
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
    int i = await DBApi.db.updateCurrentAnimal(_currentAnimal, _animals);
    log.e('ControllingProvider: Save current Animal: ' + i.toString());
  }

  resetPlayPositon() {
    setPlayAtNewestPosition();
    notifyListeners();
  }

  setAllArchieved() async {
    bool allArchieved = await DBApi.db.allArchieved();
    _allArchieved = allArchieved;
    notifyListeners();
  }

  setPlayAtNewestPosition() async {
    Level level = await DBApi.db.getHighestLevel();
    if (level == null) {
      _currentLevelCounter = 1;
      _currentLevel = await getLevelFromId();
    } else {
      log.i('ControllingProvider: HIghest Level = ' + level.number.toString() + ' ' + level.difficulty.toString());
      setLevel(level);
    }
  }

  Future<void> levelUp() async {
    if (_currentLevel.number == 1) {
      _currentLevel.achievement = true;
      await DBApi.db.updateLevel(_currentLevel);
    }
    if (_currentLevel.id != 15) {
      _currentLevelCounter += 1;
      _currentLevel = await getLevelFromId();
      _currentLevel.achievement = true;
      await DBApi.db.updateLevel(_currentLevel);
    }

    if (_currentLevel.finalLevel) {
      setAllArchieved();
    }

    log.i('ControllingProvider:' + 'New Level: $_currentLevelCounter.wav (levelUp)');

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  Future<void> setLevelAnimatedFalse() async {
    await DBApi.db.updateLevelNotAnimated();
  }

  void setLevel(Level level) {
    _currentLevel = level;
    _currentLevelCounter = level.id;

    log.i('ControllingProvider:' + 'Change level to ${LevelHelper.printLevelInfo(level)} (setLevel)');
  }

  void resetAll() {}

  Future<Level> getLevelFromId() async {
    Level level = await DBApi.db.getLevelById(_currentLevelCounter);
    log.i('ControllingProvider:' + 'Start Level with ${LevelHelper.printLevelInfo(level)} (levelUp)');
    return level;
  }
}
