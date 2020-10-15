import 'dart:math' as math;

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/menu/menu_screen.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/shared_widgets/empty_placeholder.dart';
import 'package:magic_pot/shared_widgets/play_button.dart';
import 'package:magic_pot/shared_widgets/selected_animal.dart';
import 'package:magic_pot/shared_widgets/witch.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

// TODO:  feuerwerk?????
// This screen shows that the animal is completly transformed and can now live in the woods. The witch praises the player and fireworks are shown
class LevelFinishedScreen extends StatefulWidget {
  static const String routeTag = '/levelfinished';

  @override
  State<StatefulWidget> createState() {
    return _LevelFinishedScreen();
  }
}

class _LevelFinishedScreen extends State<LevelFinishedScreen> {
  Level currentLevel;

  List<Level> finalArchievements = new List<Level>();
  String playLink = MenuScreen.routeTag;
  bool locked = true;
  bool madeInitSound = false;
  AudioPlayerService audioPlayerService;

  void initState() {
    super.initState();
    audioPlayerService = Provider.of<AudioPlayerService>(context, listen: false);
    currentLevel = Provider.of<UserStateService>(context, listen: false).currentLevel;

    _setArchievements();
  }

  _setArchievements() async {
    finalArchievements = await DBApi.db.getFinalAchievedLevels();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);
    if (madeInitSound == false) {
      madeInitSound = true;
      audioPlayerService.tellLevelFinished();
      locked = false;
    }

    var lockScreen = Provider.of<AudioPlayerService>(context).lockScreen;
    bool witchTalking = Provider.of<AudioPlayerService>(context).witchTalking;

    return Consumer<AudioPlayerService>(
      builder: (context, cart, child) {
        return new WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                body: IgnorePointer(
                    ignoring: lockScreen,
                    child: Stack(children: <Widget>[
                      Center(
                        child: DarkableImage(
                          url: 'assets/pics/animal_selection.png',
                          width: SizeUtil.width,
                          height: SizeUtil.height,
                          fit: BoxFit.fill,
                        ),
                      ),
                      // PLAY
                      Stack(children: <Widget>[
                        Positioned(
                            top: SizeUtil.getDoubleByDeviceVertical(Constant.playButtonDistanceBottom),
                            right: SizeUtil.getDoubleByDeviceHorizontal(Constant.playButtonDistanceRight),
                            child: PlayButton(
                              size: SizeUtil.getDoubleByDeviceVertical(Constant.playButtonSize),
                              pushedName: playLink,
                              active: !(lockScreen || locked),
                            )),
                        // ARCHIEVEMENTS
                        // ELEPHANT
                        Positioned(
                            bottom: SizeUtil.getDoubleByDeviceVertical(60),
                            left: SizeUtil.getDoubleByDeviceHorizontal(120),
                            child: (finalArchievements.length > 0)
                                ? Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: Image.asset(
                                      finalArchievements[0].picAftereUrl,
                                      height: 250,
                                      width: SizeUtil.getDoubleByDeviceHorizontal(250),
                                    ),
                                  )
                                : EmptyPlaceholder()),
                        // GIRAFF
                        Positioned(
                            bottom: SizeUtil.getDoubleByDeviceVertical(70),
                            left: SizeUtil.getDoubleByDeviceHorizontal(590),
                            child: (finalArchievements.length > 1)
                                ? Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: Image.asset(
                                      finalArchievements[1].picAftereUrl,
                                      height: SizeUtil.getDoubleByDeviceVertical(250),
                                      width: SizeUtil.getDoubleByDeviceHorizontal(250),
                                    ),
                                  )
                                : EmptyPlaceholder()),
                        // BIRD
                        Positioned(
                            bottom: SizeUtil.getDoubleByDeviceVertical(300),
                            left: SizeUtil.getDoubleByDeviceHorizontal(805),
                            child: (finalArchievements.length > 2)
                                ? Image.asset(
                                    finalArchievements[2].picAftereUrl,
                                    height: SizeUtil.getDoubleByDeviceVertical(200),
                                    width: SizeUtil.getDoubleByDeviceHorizontal(200),
                                  )
                                : EmptyPlaceholder()),

                        // BASIC WITCH
                        Positioned(
                            bottom: 0,
                            left: SizeUtil.getDoubleByDeviceHorizontal(800),
                            child: Witch(rotate: true, talking: false, size: Constant.witchSize)),
                        // WITCH
                        witchTalking
                            ? Positioned(
                                bottom: 0,
                                left: SizeUtil.getDoubleByDeviceHorizontal(800),
                                child: Witch(rotate: true, talking: true, size: Constant.witchSize))
                            : Container(),
                        // ANIMAL
                        Positioned(
                            left: SizeUtil.getDoubleByDeviceHorizontal(500),
                            top: SizeUtil.getDoubleByDeviceVertical(550),
                            child: IgnorePointer(
                              ignoring: lockScreen,
                              child: Positioned(
                                  left: SizeUtil.getDoubleByDeviceHorizontal(500),
                                  top: SizeUtil.getDoubleByDeviceVertical(475),
                                  child: IgnorePointer(
                                      ignoring: lockScreen, child: SelectedAnimal(size: Constant.finishedAnimalSize))),
                            )),
                        // FIREWORKS
                        Positioned(
                            top: SizeUtil.getDoubleByDeviceVertical(150),
                            left: SizeUtil.getDoubleByDeviceHorizontal(300),
                            height: SizeUtil.getDoubleByDeviceVertical(200),
                            width: SizeUtil.getDoubleByDeviceHorizontal(500),
                            child: Container(
                                child: FlareActor(
                              "assets/animation/firework_pink.flr",
                              animation: "explode",
                            ))),
                        Positioned(
                            top: SizeUtil.getDoubleByDeviceVertical(500),
                            left: SizeUtil.getDoubleByDeviceHorizontal(300),
                            height: SizeUtil.getDoubleByDeviceVertical(150),
                            width: SizeUtil.getDoubleByDeviceHorizontal(200),
                            child: Container(
                                child: FlareActor(
                              "assets/animation/firework_pink.flr",
                              animation: "explode",
                            ))),
                        Positioned(
                            top: SizeUtil.getDoubleByDeviceVertical(450),
                            left: SizeUtil.getDoubleByDeviceHorizontal(700),
                            height: SizeUtil.getDoubleByDeviceVertical(200),
                            width: SizeUtil.getDoubleByDeviceHorizontal(200),
                            child: Container(
                                child: FlareActor(
                              "assets/animation/firework_pink.flr",
                              animation: "explode",
                            ))),
                      ])
                    ]))));
      },
    );
  }
}
