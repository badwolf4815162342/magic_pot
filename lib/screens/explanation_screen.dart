import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/custom_widget/play_button.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import '../logger.util.dart';

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
      Future.delayed(Duration.zero, () {
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserModel>(context).explainCurrentLevel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final log = getLogger();
    Size size = MediaQuery.of(context).size;
    currentLevel = Provider.of<UserModel>(context, listen: false)
        .getLevelFromNumberAndDiff();

    if (currentLevel == null) {
      Navigator.pushNamed(context, "levelFinishedRoute");
    }
    if (currentLevel == null) {
      log.e('ExplanationScreen:' + 'CurrentLevel= null');
    } else {
      log.i('ExplanationScreen:' +
          'CurrentLevel=  ${LevelHelper.printLevelInfo(currentLevel)}');
    }
    var levelnum = 0;
    if (currentLevel == null) {
      levelnum = 1000;
    } else {
      levelnum = currentLevel.number;
    }

    return Scaffold(
        body: BackgroundLayout(
            scene: LayoutBuilder(
              builder: (context, constraints) => Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned(
                      bottom: double.parse(GlobalConfiguration()
                          .getString("play_button_distancd_bottom")),
                      right: double.parse(GlobalConfiguration()
                          .getString("play_button_distancd_right")),
                      child: PlayButton(
                        pushedName: "levelScreenRoute",
                        opacity: 0.7,
                        active: true,
                      )),
                  Positioned(
                    top: 180,
                    left: 60,
                    child: new Image.asset(
                      currentLevel.picurl,
                      width: 600,
                      height: 600,
                    ),
                  ),
                ],
              ),
            ),
            picUrl: 'assets/pics/level_finished_screen.png'));
  }
}
