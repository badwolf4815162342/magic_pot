import 'dart:math';

import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/custom_widget/Ingredient_draggable.dart';
import 'package:magic_pot/models/ingredient.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/util/logger.util.dart';

import 'constant.util.dart';

class LevelHelperUtil {
  final log = getLogger();

  List<Ingredient> getIngredients( List<Ingredient> lastObjects, num count ){

  }

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

  initLevelHelperUtil() {
    counter = 0;
    rightcounter = 0;
    wrongcounter = 0;
    lastright = false;
         shaking = false;
   potImage = Constant.standartPotImagePath;
   millismovement = 1000;
   angleMovement = 180;
  }

  resetLevelData(
      Level currentLevel, AudioPlayerService audioPlayerService) async {
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
  }

  bool onAccept(
      data, Level currentLevel, AudioPlayerService audioPlayerService) {
    final log = getLogger();
    log.d('LevelScreen: Data: ' +
        data +
        ' Accepted obj ' +
        acceptedObject.toString());
    if (data == acceptedObject.name) {
      // main class
      /* potImage = 'assets/pics/pot_pink2.png';
      millismovement = 1000;
      angleMovement = 180;
      this.shaking = true; */
      if (counter >= (currentLevel.numberOfMinObjects - 1) &&
          rightcounter >= (currentLevel.numberOfRightObjectsInARow - 1)) {
        audioPlayerService.praise(false);
      } else {
        audioPlayerService.praise(true);
      }
      success();
      _printLevelStateInfo();
    } else {
    
        potImage = 'assets/pics/pot_black2.png';
      millismovement = 500;
      angleMovement = 5;
      this.shaking = true; 
      failure();
    }
    // main class

    /* Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        // Here you can write your code for open new view
        this.shaking = false;
        potImage = 'assets/pics/pot_green2.png';
      });
    }); */
    log.d('LevelScreen: on except over');
  }

  _printLevelStateInfo() {
    final log = getLogger();
    log.i('LevelScreen:' +
        '_printLevelStateInfo Ingredient number $counter/${currentLevel.numberOfMinObjects} done $rightcounter/${currentLevel.numberOfRightObjectsInARow} right objects in a row.');
  }

// returns if level is now finished
  bool success() {
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
      // main class
      /*  Provider.of<UserStateService>(context, listen: false).levelUp();
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          Navigator.pushNamed(context, ExplanationScreen.routeTag);
        });
      }); */
    } else {
      // main class

      /*  setState(() {
        _resetLevelData();
      }); */
    }
  }

// resetLevel nessecary?
  bool failure(AudioPlayerService audioPlayerService) {
    wrongcounter++;
    if (wrongcounter == currentLevel.getMaxFaults()) {
      audioPlayerService.resetIngredient();
        resetLevelData(Level currentLevel, AudioPlayerService audioPlayerService);
      _printLevelStateInfo();
    } else {
      audioPlayerService.motivation();
      lastright = false;
    }
  }

  
}
 
