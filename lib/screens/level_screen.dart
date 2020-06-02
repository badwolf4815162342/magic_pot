import 'dart:math';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/custom_widget/object_draggable.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';
import 'package:magic_pot/models/object.dart';

import '../logger.util.dart';

class LevelScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LevelScreenState();
  }
}

class _LevelScreenState extends State<LevelScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  List<Object> currentObjects = new List<Object>();
  List<ObjectDraggable> currentObjectDraggables = new List<ObjectDraggable>();
  Object acceptedObject;
  int counter = 0;
  int rightcounter = 0;
  Level currentLevel;
  bool lastright = false;
  bool shaking = false;
  String potImage = 'assets/pics/pot_green2.png';
  int millismovement = 1000;
  double angleMovement = 180;

  bool _checkConfiguration() => true;

  void initState() {
    super.initState();
    if (_checkConfiguration()) {
      Future.delayed(Duration.zero, () {
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
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Level won!")));
      Provider.of<UserModel>(context, listen: false).levelUp();
      Navigator.pushNamed(context, "explanationScreenRoute");
    } else {
      setState(() {
        _resetLevelData();
      });
    }
  }

  _printLevelStateInfo() {
    final log = getLogger();
    log.i('LevelScreen:' +
        '_printLevelStateInfo Object number ${counter}/${currentLevel.numberOfMinObjects} done ${rightcounter}/${currentLevel.numberOfRightObjectsInARow} right objects in a row.');
  }

  _resetLevelData() {
    final log = getLogger();
    log.i('LevelScreen:' + "reset level (_resetLevelData)");
    var objects = Provider.of<UserModel>(context).objects;
    var random = new Random();
    currentObjects = new List<Object>();
    currentObjectDraggables = new List<ObjectDraggable>();
    var numbers = new List<int>();
    for (int i = 0; i < currentLevel.numberOfObjectsToChooseFrom; i++) {
      var randomInt = random.nextInt(objects.length);
      // no duplicats
      while (numbers.contains(randomInt)) {
        randomInt = random.nextInt(objects.length);
      }
      numbers.add(randomInt);
      currentObjects.add(objects[randomInt]);
      currentObjectDraggables
          .add(new ObjectDraggable(object: objects[randomInt]));
    }
    acceptedObject = currentObjects[random.nextInt(currentObjects.length)];
    log.i('LevelScreen:' + "Acc ${acceptedObject.name}");
    Provider.of<UserModel>(context)
        .updateWitchText('audio/${acceptedObject.name}.wav');
    Provider.of<UserModel>(context)
        .explainAcceptedObject('audio/${acceptedObject.name}.wav');
  }

  @override
  Widget build(BuildContext context) {
    currentLevel = Provider.of<UserModel>(context, listen: false)
        .getLevelFromNumberAndDiff();

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

        ///scaffoldKey.currentState
        //     .showSnackBar(SnackBar(content: Text("Correct!")));
        Provider.of<UserModel>(context).praise();
        _success();
        _printLevelStateInfo();
      } else {
        potImage = 'assets/pics/pot_black2.png';
        millismovement = 500;
        angleMovement = 5;
        this.shaking = true;
        //scaffoldKey.currentState
        //    .showSnackBar(SnackBar(content: Text("Wrong!")));
        Provider.of<UserModel>(context).motivation();
        lastright = false;
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
              builder: (context, constraints) => Stack(
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: currentObjectDraggables,
                    ),
                  ])
                ],
              ),
            ),
            picUrl: 'assets/pics/level_background.png'));
  }
}
