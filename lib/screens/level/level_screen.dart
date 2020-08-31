import 'dart:math';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/ingredient.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/level/ingredient_draggable.dart';
import 'package:magic_pot/screens/level/ingredient_draggable_list.dart';
import 'package:magic_pot/shared_widgets/background_layout.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/level_helper.util.dart';
import 'package:provider/provider.dart';

import '../../util/logger.util.dart';

class LevelScreen extends StatefulWidget {
  static const String routeTag = '/levelscreen';
  final log = getLogger();

  @override
  State<StatefulWidget> createState() {
    return _LevelScreenState();
  }
}

class _LevelScreenState extends State<LevelScreen> {
  final log = getLogger();
  AudioPlayerService audioPlayerService;
  bool madeInitSound = false;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  // --
  List<Ingredient> currentObjects = new List<Ingredient>();
  List<IngredientDraggable> currentIngredientDraggables =
      new List<IngredientDraggable>();
  Ingredient acceptedObject;
  int counter = 0;
  int rightcounter = 0;
  int wrongcounter = 0;
  Level currentLevel;
  bool lastright = false;
  // --
  bool shaking = false;
  String potImage = Constant.standartPotImagePath;
  int millismovement = 1000;
  double angleMovement = 180;

  void initState() {
    super.initState();
    currentLevel =
        Provider.of<UserStateService>(context, listen: false).currentLevel;
  }

  _success() {
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
      Provider.of<UserStateService>(context, listen: false).levelUp();
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          Navigator.pushNamed(context, ExplanationScreen.routeTag);
        });
      });
    } else {
      setState(() {
        _resetLevelData();
      });
    }
  }

  _failure() {
    wrongcounter++;
    if (wrongcounter == currentLevel.getMaxFaults()) {
      audioPlayerService.resetIngredient();
      setState(() {
        _resetLevelData();
      });
      _printLevelStateInfo();
    } else {
      audioPlayerService.motivation();
      lastright = false;
    }
  }

  _printLevelStateInfo() {
    final log = getLogger();
    log.i('LevelScreen:' +
        '_printLevelStateInfo Ingredient number $counter/${currentLevel.numberOfMinObjects} done $rightcounter/${currentLevel.numberOfRightObjectsInARow} right objects in a row.');
  }

  _resetLevelData() async {
    final log = getLogger();
    log.i('LevelScreen:' + "reset level (_resetLevelData)");
    currentObjects = await LevelHelperUtil.getIngredients(null, currentLevel);
    currentIngredientDraggables =
        LevelHelperUtil.getIngredientDraggables(currentObjects);

    var random = new Random();
    acceptedObject = currentObjects[random.nextInt(currentObjects.length)];

    log.i('LevelScreen:' + "Acc ${acceptedObject.name}");

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        audioPlayerService.explainAcceptedObject(
          'audio/witch_${acceptedObject.name}.wav',
        );
      });
    });
    log.d('LevelScreen: on except over');
  }

  _onAccept(data) {
    log.d('LevelScreen: Data: ' +
        data +
        ' Accepted obj ' +
        acceptedObject.toString());
    if (data == acceptedObject.name) {
      _setPotAnimationSuccess();
      if (counter >= (currentLevel.numberOfMinObjects - 1) &&
          rightcounter >= (currentLevel.numberOfRightObjectsInARow - 1)) {
        // if enaugh right objects found praise and don't say normal text (next level text will be told)
        audioPlayerService.praise(false);
      } else {
        audioPlayerService.praise(true);
      }
      _success();
      _printLevelStateInfo();
    } else {
      _setPotAnimationFailure();
      _failure();
    }
    _stopPotAnimation();
    log.d('LevelScreen: on except over');
  }

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);

    if (madeInitSound == false) {
      madeInitSound = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        _resetLevelData();
      });
    }

    return Scaffold(
        key: scaffoldKey,
        body: BackgroundLayout(
            scene: LayoutBuilder(
              builder: (context, constraints) {
                //var ingredientDraggables = IngredientDraggables;
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Row(children: [
                      SizedBox(width: 80),
                      Column(children: [
                        SizedBox(height: 450),
                        ShakeAnimatedWidget(
                          enabled: this.shaking,
                          duration: Duration(milliseconds: millismovement),
                          shakeAngle: Rotation.deg(z: angleMovement),
                          curve: Curves.linear,
                          child: DragTarget(
                            builder: (context, List<String> strings,
                                unacceptedObjectList) {
                              return Center(
                                child: DarkableImage(
                                  url: this.potImage,
                                  width: 300,
                                  height: 300,
                                ),
                              );
                            },
                            onWillAccept: (data) {
                              return true;
                            },
                            onAccept: (data) {
                              _onAccept(data);
                            },
                          ),
                        ),
                      ]),
                    ]),
                    Row(children: [
                      SizedBox(height: 10, width: 580),
                      IngredientDraggableList(
                          currentDraggables: currentIngredientDraggables)
                    ])
                  ],
                );
              },
            ),
            picUrl: 'assets/pics/level_background.png'));
  }

  void _setPotAnimationFailure() {
    potImage = 'assets/pics/pot_black2.png';
    millismovement = 500;
    angleMovement = 5;
    this.shaking = true;
  }

  void _setPotAnimationSuccess() {
    potImage = 'assets/pics/pot_pink2.png';
    millismovement = 1000;
    angleMovement = 180;
    this.shaking = true;
  }

  void _stopPotAnimation() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        // Here you can write your code for open new view
        this.shaking = false;
        potImage = 'assets/pics/pot_green2.png';
      });
    });
  }
}
