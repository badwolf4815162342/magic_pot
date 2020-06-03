import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/custom_widget/play_button.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:magic_pot/screens/level_screen.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import '../logger.util.dart';

class ExplanationScreen extends StatefulWidget {
  static const String tag = '/explanation';

  @override
  State<StatefulWidget> createState() {
    return _ExplanationScreenState();
  }
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  Level currentLevel;
  bool trans;
  bool _checkConfiguration() => true;

  void initState() {
    super.initState();
    if (_checkConfiguration()) {
      Future.delayed(const Duration(milliseconds: 4000), () {
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserModel>(context, listen: false).transitionSound();
        trans = true;
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
      Navigator.pushNamed(context, "/levelfinished");
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
                        pushedName: LevelScreen.tag,
                        opacity: 0.7,
                        active: true,
                      )),
                  Positioned(
                      top: 180,
                      left: 60,
                      child: Stack(
                        children: <Widget>[
                          OpacityAnimatedWidget.tween(
                            duration: Duration(milliseconds: 5000),
                            opacityEnabled: 1, //define start value
                            opacityDisabled: 0, //and end value
                            enabled: trans, //bind with the boolean
                            child: new Image.asset(
                              currentLevel.picAftereUrl,
                              width: 600,
                              height: 600,
                            ),
                          ),
                          OpacityAnimatedWidget.tween(
                            duration: Duration(milliseconds: 5000),
                            opacityEnabled: 0, //define start value
                            opacityDisabled: 1, //and end value
                            enabled: trans, //bind with the boolean
                            child: new Image.asset(
                              currentLevel.picBeforeUrl,
                              width: 600,
                              height: 600,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            picUrl: 'assets/pics/level_finished_screen.png'));
  }
}
