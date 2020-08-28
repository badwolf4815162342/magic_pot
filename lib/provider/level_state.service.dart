/* import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/custom_widget/ingredient_draggable.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/ingredient.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/util/constant.util.dart';

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

  resetLevelData(AudioPlayerService audioPlayerService) async {
    log.i('LevelScreen:' + "reset level (_resetLevelData)");
    //var objects = Provider.of<ControllingProvider>(context).objects;
    currentObjects = await DBApi.db
        .getXRandomObjects(currentLevel.numberOfObjectsToChooseFrom);
    currentIngredientDraggables = new List<IngredientDraggable>();
    currentObjects.forEach((element) {
      currentIngredientDraggables
          .add(new IngredientDraggable(ingredient: element));
    });

    var random = new Random();
    acceptedObject = currentObjects[random.nextInt(currentObjects.length)];
    log.i('LevelScreen:' + "Acc ${acceptedObject.name}");
    audioPlayerService
        .updateWitchText('audio/witch_${acceptedObject.name}.wav');
    // In main class
    /* Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        audioPlayerService.explainAcceptedObject(
          'audio/witch_${acceptedObject.name}.wav',
        );
      });
    }); */
    log.d('LevelScreen: on except over');
    notifyListeners();
  }

  bool onAccept(data, AudioPlayerService audioPlayerService) {
    final log = getLogger();
    log.d('LevelScreen: Data: ' +
        data +
        ' Accepted obj ' +
        acceptedObject.toString());
    if (data == acceptedObject.name) {
      potImage = 'assets/pics/pot_pink2.png';
      millismovement = 1000;
      angleMovement = 180;
      this.shaking = true;
      notifyListeners();
      if (counter >= (currentLevel.numberOfMinObjects - 1) &&
          rightcounter >= (currentLevel.numberOfRightObjectsInARow - 1)) {
        audioPlayerService.praise(false);
      } else {
        audioPlayerService.praise(true);
      }
      success(audioPlayerService);
      _printLevelStateInfo();
    } else {
      potImage = 'assets/pics/pot_black2.png';
      millismovement = 500;
      angleMovement = 5;
      this.shaking = true;
      notifyListeners();
      failure(audioPlayerService);
    }
    Future.delayed(const Duration(milliseconds: 3000), () {
      // Here you can write your code for open new view
      this.shaking = false;
      potImage = 'assets/pics/pot_green2.png';
      notifyListeners();
    });
    log.d('LevelScreen: on except over');
  }

  _printLevelStateInfo() {
    final log = getLogger();
    log.i('LevelScreen:' +
        '_printLevelStateInfo Ingredient number $counter/${currentLevel.numberOfMinObjects} done $rightcounter/${currentLevel.numberOfRightObjectsInARow} right objects in a row.');
  }

// returns if level is now finished
  bool success(AudioPlayerService audioPlayerService, UserStateService userStateService) {
    final log = getLogger();
    counter++;
    if (lastright) {
      rightcounter++;
    } else {
      rightcounter = 1;
    }
    lastright = true;
    log.i('LevelScreen:' + 'Levelcounter=  New counter $counter');
    if (counter >= currentLevel.numberOfMinObjects &&
        rightcounter >= currentLevel.numberOfRightObjectsInARow) {
        userStateService.levelUp();
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          Navigator.pushNamed(context, ExplanationScreen.routeTag);
        });
      }); 
    } else {
      // main class

      resetLevelData(audioPlayerService);
    }
  }

// resetLevel nessecary?
  bool failure(AudioPlayerService audioPlayerService) {
    wrongcounter++;
    if (wrongcounter == currentLevel.getMaxFaults()) {
      audioPlayerService.resetIngredient();
      resetLevelData(audioPlayerService);
      _printLevelStateInfo();
    } else {
      audioPlayerService.motivation();
      lastright = false;
    }
  }
}
 */
