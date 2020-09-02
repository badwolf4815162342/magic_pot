import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:magic_pot/models/ingredient.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/screens/level/ingredient_draggable.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/level_helper.util.dart';

import '../util/logger.util.dart';

class LevelStateService extends ChangeNotifier {
  final log = getLogger();

  List<Ingredient> _currentObjects = new List<Ingredient>();
  List<IngredientDraggable> _currentIngredientDraggables = new List<IngredientDraggable>();
  Ingredient _acceptedObject;

  int _counter;
  int _rightcounter;
  int _wrongcounter;
  bool _lastright;

  // MagicPot
  bool _shaking;
  String _potImage;
  int _millismovement;
  double _angleMovement;

  Level currentLevel;
  double _fontSize;
  // bool _readyForNextLevel;

  Ingredient get acceptedObject => _acceptedObject;
  List<IngredientDraggable> get currentIngredientDraggables => _currentIngredientDraggables;

  bool get shaking => _shaking;
  String get potImage => _potImage;
  int get millismovement => _millismovement;
  double get angleMovement => _angleMovement;

  int get counter => _counter;
  int get rightcounter => _rightcounter;
  int get wrongcounter => _wrongcounter;

  LevelStateService(Level currentLevel, double fontsize) {
    this.currentLevel = currentLevel;
    this._fontSize = fontsize;
    initLevelStateService();
  }

  initLevelStateService() {
    _counter = 0;
    _rightcounter = 0;
    _wrongcounter = 0;
    _lastright = false;
    _shaking = false;
    _potImage = Constant.standartPotImagePath;
    _millismovement = 1000;
    _angleMovement = 180;
  }

  resetLevelData() async {
    _currentObjects = await LevelHelperUtil.getIngredients(null, currentLevel);
    _currentIngredientDraggables = LevelHelperUtil.getIngredientDraggables(_currentObjects, this._fontSize);

    var random = new Random();
    _acceptedObject = _currentObjects[random.nextInt(_currentObjects.length)];
    log.i('LevelScreen:' + "Acc ${_acceptedObject.name}");

    log.d('LevelScreen: on except over');
    notifyListeners();
  }

  printLevelStateInfo() {
    final log = getLogger();
    log.i('LevelScreen:' +
        '_printLevelStateInfo Ingredient number $_counter/${currentLevel.numberOfMinObjects} done $_rightcounter/${currentLevel.numberOfRightObjectsInARow} right objects in a row.');
  }

  success() {
    final log = getLogger();
    _counter++;
    if (_lastright) {
      _rightcounter++;
    } else {
      _rightcounter = 1;
    }
    _lastright = true;
    log.i('LevelScreen:' + 'Levelcounter=  New counter $_counter');
    notifyListeners();
  }

  failure() {
    _wrongcounter++;
    if (_wrongcounter == currentLevel.getMaxFaults()) {
      resetLevelData();
      printLevelStateInfo();
    } else {
      _lastright = false;
    }
    notifyListeners();
  }

  void setPotAnimationFailure() {
    _potImage = 'assets/pics/pot_black2.png';
    _millismovement = 500;
    _angleMovement = 5;
    _shaking = true;
    notifyListeners();
  }

  void setPotAnimationSuccess() {
    _potImage = 'assets/pics/pot_pink2.png';
    _millismovement = 1000;
    _angleMovement = 180;
    _shaking = true;
    notifyListeners();
  }

  void stopPotAnimation() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      // Here you can write your code for open new view
      _shaking = false;
      _potImage = 'assets/pics/pot_green2.png';
      notifyListeners();
    });
  }
}
