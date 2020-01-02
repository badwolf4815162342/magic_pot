import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/custom_widget/object_draggable.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';
import 'package:magic_pot/models/object.dart';

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

  _success() {
    counter++;
    if (lastright) {
      rightcounter++;
    } else {
      rightcounter = 1;
    }
    lastright = true;

    print("New counter ${counter}");
    if (counter >= currentLevel.numberOfMinObjects &&
        rightcounter >= currentLevel.numberOfRightObjectsInARow) {
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Level won!")));
      Provider.of<UserModel>(context, listen: false).levelUp();
      Navigator.pop(context);
    } else {
      setState(() {
        _resetLevelData();
      });
    }
  }

  _printLevelStateInfo() {
    print("Info:");
    print(
        "Object number ${counter}/${currentLevel.numberOfMinObjects} done ${rightcounter}/${currentLevel.numberOfRightObjectsInARow} right objects in a row.");
  }

  _resetLevelData() {
    print("reset level");
    var objects = Provider.of<UserModel>(context).objects;
    var random = new Random();
    currentObjects = new List<Object>();
    currentObjectDraggables = new List<ObjectDraggable>();
    for (int i = 0; i < currentLevel.numberOfObjectsToChooseFrom; i++) {
      var randomInt = random.nextInt(objects.length);
      currentObjects.add(objects[randomInt]);
      currentObjectDraggables
          .add(new ObjectDraggable(object: objects[randomInt]));
    }
    acceptedObject = currentObjects[random.nextInt(currentObjects.length)];
    print("Acc ${acceptedObject.name}");
  }

  @override
  Widget build(BuildContext context) {
    currentLevel = Provider.of<UserModel>(context, listen: false)
        .getLevelFromNumberAndDiff();

    _resetLevelData();

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Routing & Navigation"),
        ),
        body: BackgroundLayout(
          scene: LayoutBuilder(
            builder: (context, constraints) => Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DragTarget(
                      builder: (context, List<String> strings,
                          unacceptedObjectList) {
                        return Center(
                            child: Text("🍵",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 300,
                                )));
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                      onAccept: (data) {
                        print(data);
                        print(acceptedObject);
                        if (data == acceptedObject.name) {
                          scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Correct!")));
                          _success();
                          _printLevelStateInfo();
                        } else {
                          scaffoldKey.currentState
                              .showSnackBar(SnackBar(content: Text("Wrong!")));
                          lastright = false;
                        }
                        print("on except over");
                      },
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: currentObjectDraggables,
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
