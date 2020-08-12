import 'dart:math';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/custom_widget/ingredient_draggable.dart';
import 'package:magic_pot/custom_widget/ingredient_draggables.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:magic_pot/provider/db_provider.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:provider/provider.dart';
import 'package:magic_pot/models/ingredient.dart';

import '../logger.util.dart';

class LevelScreen extends StatefulWidget {
  static const String routeTag = '/levelscreen';

  @override
  State<StatefulWidget> createState() {
    return _LevelScreenState();
  }
}

class _LevelScreenState extends State<LevelScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  List<Ingredient> currentObjects = new List<Ingredient>();
  List<IngredientDraggable> currentIngredientDraggables =
      new List<IngredientDraggable>();
  Ingredient acceptedObject;
  int counter = 0;
  int rightcounter = 0;
  int wrongcounter = 0;
  Level currentLevel;
  bool lastright = false;
  bool shaking = false;
  String potImage = 'assets/pics/pot_green2.png';
  int millismovement = 1000;
  double angleMovement = 180;

  bool _checkConfiguration() => true;

  void initState() {
    super.initState();
    currentLevel =
        Provider.of<ControllingProvider>(context, listen: false).currentLevel;
    if (_checkConfiguration()) {
      Future.delayed(const Duration(milliseconds: 500), () {
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        _resetLevelData();
      });
    }
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
    log.i('LevelScreen:' + 'Levelcounter=  New counter ${counter}');
    if (counter >= currentLevel.numberOfMinObjects &&
        rightcounter >= currentLevel.numberOfRightObjectsInARow) {
      Provider.of<ControllingProvider>(context, listen: false).levelUp();
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
    final log = getLogger();
    wrongcounter++;
    if (wrongcounter == currentLevel.getMaxFaults()) {
      Provider.of<ControllingProvider>(context).reset_ingr();
      setState(() {
        _resetLevelData();
      });
      _printLevelStateInfo();
    } else {
      Provider.of<ControllingProvider>(context).motivation();
      lastright = false;
    }
  }

  _printLevelStateInfo() {
    final log = getLogger();
    log.i('LevelScreen:' +
        '_printLevelStateInfo Ingredient number ${counter}/${currentLevel.numberOfMinObjects} done ${rightcounter}/${currentLevel.numberOfRightObjectsInARow} right objects in a row.');
  }

  _resetLevelData() async {
    final log = getLogger();
    log.i('LevelScreen:' + "reset level (_resetLevelData)");
    //var objects = Provider.of<ControllingProvider>(context).objects;
    currentObjects = await DBProvider.db
        .getXRandomObjects(currentLevel.numberOfObjectsToChooseFrom);
    currentIngredientDraggables = new List<IngredientDraggable>();
    currentObjects.forEach((element) {
      currentIngredientDraggables
          .add(new IngredientDraggable(ingredient: element));
    });

    var random = new Random();
    acceptedObject = currentObjects[random.nextInt(currentObjects.length)];
    log.i('LevelScreen:' + "Acc ${acceptedObject.name}");
    Provider.of<ControllingProvider>(context)
        .updateWitchText('audio/witch_${acceptedObject.name}.wav');
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        Provider.of<ControllingProvider>(context)
            .explainAcceptedObject('audio/witch_${acceptedObject.name}.wav');
      });
    });
    log.d('LevelScreen: on except over');
  }

  @override
  Widget build(BuildContext context) {
    // _getCurrentLevel();

    //_resetLevelData();

    _onAccept(data) {
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
        if (counter >= (currentLevel.numberOfMinObjects - 1) &&
            rightcounter >= (currentLevel.numberOfRightObjectsInARow - 1)) {
          Provider.of<ControllingProvider>(context).praise(false);
        } else {
          Provider.of<ControllingProvider>(context).praise(true);
        }
        _success();
        _printLevelStateInfo();
      } else {
        potImage = 'assets/pics/pot_black2.png';
        millismovement = 500;
        angleMovement = 5;
        this.shaking = true;
        _failure();
      }
      Future.delayed(const Duration(milliseconds: 3000), () {
        setState(() {
          // Here you can write your code for open new view
          this.shaking = false;
          potImage = 'assets/pics/pot_green2.png';
        });
      });
      log.d('LevelScreen: on except over');
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
                                child: new Image.asset(
                                  this.potImage,
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
                      IngredientDraggables(
                          currentDraggables: currentIngredientDraggables)
                    ])
                  ],
                );
              },
            ),
            picUrl: 'assets/pics/level_background.png'));
  }
}
