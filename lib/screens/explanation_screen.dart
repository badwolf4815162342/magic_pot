import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/level_finished_screen.dart';
import 'package:magic_pot/screens/level/level_screen.dart';
import 'package:magic_pot/shared_widgets/background_layout.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/shared_widgets/empty_placeholder.dart';
import 'package:magic_pot/shared_widgets/play_button.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

import '../util/logger.util.dart';

// Screen between the levels/potions to show the transformation steps of the animal
class ExplanationScreen extends StatefulWidget {
  static const String routeTag = '/explanation';

  @override
  State<StatefulWidget> createState() {
    return _ExplanationScreenState();
  }
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  Level currentLevel;
  bool transformation;
  String playLink;
  bool locked = true;
  AudioPlayerService audioPlayerService;
  bool madeInitSound = false;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);

    if (madeInitSound == false) {
      madeInitSound = true;
      currentLevel = Provider.of<UserStateService>(context, listen: false).currentLevel;
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (currentLevel.number != 1) {
          audioPlayerService.transitionSound();
          transformation = true;
        }

        Future.delayed(const Duration(milliseconds: 1000), () {
          audioPlayerService.explainCurrentLevel(currentLevel);
        });

        Future.delayed(const Duration(milliseconds: 5000), () {
          if (currentLevel.finalLevel) {
            Provider.of<UserStateService>(context, listen: false).levelUp();
          }
        });

        locked = false;
      });
    }
    var lockScreen = Provider.of<AudioPlayerService>(context).lockScreen;
    final log = getLogger();
    playLink = LevelScreen.routeTag;

    if (currentLevel == null) {
      log.e('ExplanationScreen:' + 'CurrentLevel= null');
    } else {
      log.i('ExplanationScreen:' + 'CurrentLevel=  ${LevelHelper.printLevelInfo(currentLevel)}');
      if (currentLevel.finalLevel) {
        playLink = LevelFinishedScreen.routeTag;
      }
    }

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: BackgroundLayout(
                scene: LayoutBuilder(
                  builder: (context, constraints) => Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned(
                          bottom: Constant.playButtonDistanceBottom,
                          right: Constant.playButtonDistanceRight,
                          child: PlayButton(
                            size: SizeUtil.getDoubleByDeviceVertical(Constant.playButtonSize),
                            pushedName: playLink,
                            active: !(lockScreen || locked),
                          )),
                      Positioned(
                          top: SizeUtil.getDoubleByDeviceVertical(230),
                          left: SizeUtil.getDoubleByDeviceHorizontal(60),
                          child: Stack(
                            children: <Widget>[
                              // Transformation animation
                              OpacityAnimatedWidget.tween(
                                duration: Duration(milliseconds: 5000),
                                opacityEnabled: 1, //define start value
                                opacityDisabled: 0, //and end value
                                enabled: transformation, //bind with the boolean
                                child: (currentLevel != null)
                                    ? DarkableImage(
                                        url: currentLevel.picAftereUrl,
                                        width: SizeUtil.getDoubleByDeviceHorizontal(Constant.transformationAnimalWidth),
                                        height: SizeUtil.getDoubleByDeviceVertical(Constant.transformationAnimalHeight),
                                      )
                                    : EmptyPlaceholder(),
                              ),
                              OpacityAnimatedWidget.tween(
                                duration: Duration(milliseconds: 5000),
                                opacityEnabled: 0, //define start value
                                opacityDisabled: 1, //and end value
                                enabled: transformation, //bind with the boolean
                                child: (currentLevel != null)
                                    ? DarkableImage(
                                        url: currentLevel.picBeforeUrl,
                                        width: SizeUtil.getDoubleByDeviceHorizontal(Constant.transformationAnimalWidth),
                                        height: SizeUtil.getDoubleByDeviceVertical(Constant.transformationAnimalHeight),
                                      )
                                    : EmptyPlaceholder(),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                picUrl: 'assets/pics/level_finished_screen.png')));
  }
}
