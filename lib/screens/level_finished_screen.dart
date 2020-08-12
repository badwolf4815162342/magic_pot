import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/empty_placeholder.dart';
import 'package:magic_pot/custom_widget/play_button.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:magic_pot/provider/db_provider.dart';
import 'package:magic_pot/screens/menu_screen.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

import 'dart:math' as math;

class LevelFinishedScreen extends StatefulWidget {
  static const String routeTag = '/levelfinished';

  @override
  State<StatefulWidget> createState() {
    return _LevelFinishedScreen();
  }
}

class _LevelFinishedScreen extends State<LevelFinishedScreen> {
  bool _checkConfiguration() => true;
  List<Level> finalArchievements = new List<Level>();
  String playLink = MenuScreen.routeTag;
  bool locked = true;

  void initState() {
    super.initState();
    _setArchievements();
    if (_checkConfiguration()) {
      Future.delayed(Duration.zero, () {
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<ControllingProvider>(context, listen: false)
            .tellLevelFinished();
        //Provider.of<ControllingProvider>(context).levelUp();
      });
      locked = false;
    }
  }

  _setArchievements() async {
    finalArchievements = await DBProvider.db.getFinalArchievedLevels();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var lockScreen = Provider.of<ControllingProvider>(context).lockScreen;
    var witchIcon = Provider.of<ControllingProvider>(context).witchIcon;
    var animal = Provider.of<ControllingProvider>(context).currentAnimal;

    return Consumer<ControllingProvider>(
      builder: (context, cart, child) {
        return Scaffold(
            body: IgnorePointer(
                ignoring: lockScreen,
                child: Stack(children: <Widget>[
                  Center(
                    child: new Image.asset(
                      'assets/pics/animal_selection.png',
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // PLAY
                  Stack(children: <Widget>[
                    Positioned(
                        top: double.parse(GlobalConfiguration()
                            .getString("play_button_distancd_bottom")),
                        right: double.parse(GlobalConfiguration()
                            .getString("play_button_distancd_right")),
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
                    // WITCH
                    Positioned(
                        bottom: 0,
                        left: 800,
                        child: FlatButton(
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: new Image.asset(
                              witchIcon,
                              height: 500,
                              width: 500,
                            ),
                          ),
                          onPressed: () {
                            Provider.of<ControllingProvider>(context)
                                .playWitchText();
                          },
                        )),
                    // ANIMAL
                    Positioned(
                        left: 500,
                        top: 550,
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                              width: 180,
                              height: 180,
                              child: RawMaterialButton(
                                child: (animal == null)
                                    ? EmptyPlaceholder()
                                    : new Image.asset(
                                        animal.picture,
                                      ),
                                onPressed: () {
                                  Provider.of<ControllingProvider>(context,
                                          listen: false)
                                      .makeAnimalSound(animal.soundfile);
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

  static void startFlare(FlareActor flare) {}
}
