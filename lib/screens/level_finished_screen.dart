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
import 'package:magic_pot/util/constant.util.dart';
import 'package:provider/provider.dart';

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
    audioPlayerService =
        Provider.of<AudioPlayerService>(context, listen: false);
    currentLevel =
        Provider.of<UserStateService>(context, listen: false).currentLevel;

    _setArchievements();
  }

  _setArchievements() async {
    finalArchievements = await DBApi.db.getFinalArchievedLevels();
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

    Size size = MediaQuery.of(context).size;
    var lockScreen = Provider.of<AudioPlayerService>(context).lockScreen;
    bool witchTalking = Provider.of<AudioPlayerService>(context).witchTalking;
    var animal = Provider.of<UserStateService>(context).currentAnimal;

    return Consumer<AudioPlayerService>(
      builder: (context, cart, child) {
        return Scaffold(
            body: IgnorePointer(
                ignoring: lockScreen,
                child: Stack(children: <Widget>[
                  Center(
                    child: DarkableImage(
                      url: 'assets/pics/animal_selection.png',
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // PLAY
                  Stack(children: <Widget>[
                    Positioned(
                        top: Constant.playButtonDistanceBottom,
                        right: Constant.playButtonDistanceRight,
                        child: PlayButton(
                          pushedName: playLink,
                          active: !(lockScreen || locked),
                        )),
                    // ARCHIEVEMENTS
                    Positioned(
                        bottom: 60,
                        left: 120,
                        child: (finalArchievements.length > 0)
                            ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Image.asset(
                                  finalArchievements[0].picAftereUrl,
                                  height: 250,
                                  width: 250,
                                ),
                              )
                            : EmptyPlaceholder()),
                    Positioned(
                        bottom: 70,
                        left: 590,
                        child: (finalArchievements.length > 1)
                            ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: Image.asset(
                                  finalArchievements[1].picAftereUrl,
                                  height: 250,
                                  width: 250,
                                ),
                              )
                            : EmptyPlaceholder()),
                    Positioned(
                        bottom: 300,
                        left: 805,
                        child: (finalArchievements.length > 2)
                            ? Image.asset(
                                finalArchievements[2].picAftereUrl,
                                height: 200,
                                width: 200,
                              )
                            : EmptyPlaceholder()),
                    // BASIC WITCH
                    Positioned(
                        bottom: 0,
                        left: 800,
                        child: FlatButton(
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: new Image.asset(
                                Constant.standartWitchIconPath,
                                height: 500,
                                width: 500,
                              )),
                          onPressed: () {
                            audioPlayerService.playWitchText();
                          },
                        )),
                    // WITCH
                    witchTalking
                        ? Positioned(
                            bottom: 0,
                            left: 800,
                            child: FlatButton(
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(math.pi),
                                child: new Image.asset(
                                  Constant.talkingWitchIconPath,
                                  height: 500,
                                  width: 500,
                                ),
                              ),
                              onPressed: () {},
                            ))
                        : Container(),
                    // ANIMAL
                    Positioned(
                        left: 500,
                        top: 550,
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                              child: RawMaterialButton(
                                child: (animal == null)
                                    ? EmptyPlaceholder()
                                    : DarkableImage(
                                        url: animal.picture,
                                        width: 180,
                                        height: 180,
                                        fit: BoxFit.fitWidth),
                                onPressed: () {
                                  audioPlayerService.makeAnimalSound(
                                    animal.soundfile,
                                  );
                                },
                              ),
                            ))),
                    // FIREWORKS
                    Positioned(
                        top: 150,
                        left: 300,
                        height: 200,
                        width: 500,
                        child: Container(
                            child: FlareActor(
                          "assets/animation/firework_pink.flr",
                          animation: "explode",
                        ))),
                    Positioned(
                        top: 500,
                        left: 300,
                        height: 150,
                        width: 200,
                        child: Container(
                            child: FlareActor(
                          "assets/animation/firework_pink.flr",
                          animation: "explode",
                        ))),
                    Positioned(
                        top: 450,
                        left: 700,
                        height: 200,
                        width: 200,
                        child: Container(
                            child: FlareActor(
                          "assets/animation/firework_pink.flr",
                          animation: "explode",
                        ))),
                  ])
                ])));
      },
    );
  }
}
