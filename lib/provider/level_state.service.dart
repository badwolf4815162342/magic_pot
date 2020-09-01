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

  List<Ingredient> currentObjects = new List<Ingredient>();
  List<IngredientDraggable> currentIngredientDraggables =
      new List<IngredientDraggable>();
  Ingredient acceptedObject;

  int counter = 0;
  int rightcounter = 0;
  int wrongcounter = 0;
  bool lastright = false;

  // MagicPot
  bool shaking = false;
  String potImage = Constant.standartPotImagePath;
  int millismovement = 1000;
  double angleMovement = 180;

  Level currentLevel;
  bool readyForNextLevel;

  LevelStateService(Level currentLevel) {
    this.currentLevel = currentLevel;
    initLevelStateService();
  }

  initLevelStateService() {
    counter = 0;
    rightcounter = 0;
    wrongcounter = 0;
    lastright = false;
    shaking = false;
    potImage = Constant.standartPotImagePath;
    millismovement = 1000;
    angleMovement = 180;
  }

  resetLevelData() async {
    currentObjects = await LevelHelperUtil.getIngredients(null, currentLevel);
    currentIngredientDraggables =
        LevelHelperUtil.getIngredientDraggables(currentObjects);

    var random = new Random();
    acceptedObject = currentObjects[random.nextInt(currentObjects.length)];
    log.i('LevelScreen:' + "Acc ${acceptedObject.name}");

    log.d('LevelScreen: on except over');
    notifyListeners();
  }

  printLevelStateInfo() {
    final log = getLogger();
    log.i('LevelScreen:' +
        '_printLevelStateInfo Ingredient number $counter/${currentLevel.numberOfMinObjects} done $rightcounter/${currentLevel.numberOfRightObjectsInARow} right objects in a row.');
  }

  success() {
    final log = getLogger();
    counter++;
    if (lastright) {
      rightcounter++;
    } else {
      rightcounter = 1;
    }
    lastright = true;
    log.i('LevelScreen:' + 'Levelcounter=  New counter $counter');
    notifyListeners();
  }

  failure() {
    wrongcounter++;
    if (wrongcounter == currentLevel.getMaxFaults()) {
      resetLevelData();
      printLevelStateInfo();
    } else {
      lastright = false;
    }
    notifyListeners();
  }

  void setPotAnimationFailure() {
    potImage = 'assets/pics/pot_black2.png';
    millismovement = 500;
    angleMovement = 5;
    this.shaking = true;
    notifyListeners();
  }

  void setPotAnimationSuccess() {
    potImage = 'assets/pics/pot_pink2.png';
    millismovement = 1000;
    angleMovement = 180;
    this.shaking = true;
    notifyListeners();
  }

  void stopPotAnimation() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      // Here you can write your code for open new view
      this.shaking = false;
      potImage = 'assets/pics/pot_green2.png';
      notifyListeners();
    });
  }
}
