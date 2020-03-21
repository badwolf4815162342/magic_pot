
import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class ExplanationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExplanationScreenState();
  }
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  Level currentLevel;

  bool _checkConfiguration() => true;

  void initState() {
    super.initState();
    if (_checkConfiguration()) {
      Future.delayed(Duration.zero,() { // SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserModel>(context).explainCurrentLevel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    currentLevel = Provider.of<UserModel>(context, listen: false)
        .getLevelFromNumberAndDiff();
      if (currentLevel == null) {
        Navigator.pushNamed(context, "levelFinishedRoute");
      } 
    if (currentLevel == null) {
      print("nulllevel");
    } else {
      print("currentlevel = ${LevelHelper.printLevelInfo(currentLevel)}");
    }

    var levelnum = 0;
    if (currentLevel == null) {
      levelnum = 1000;
    } else {
      levelnum = currentLevel.number;
    }

    return Scaffold(
      body: BackgroundLayout(
          scene: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                /* Text(
                  'Explanation .... ${levelnum}',
                  style: TextStyle(color: Colors.black),
                ),*/
                RawMaterialButton(
                      child: new Image.asset(
                          'assets/pics/arm_wand.png',
                          width: 400,
                        ),
                  onPressed: () {
                    Navigator.pushNamed(context, "levelScreenRoute");
                  },
                ),
              ])),
          picUrl: 'assets/pics/level_finished_screen.png'),
    );
  }
}
