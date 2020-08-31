import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/screens/animal_selection/animal_button_list.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:provider/provider.dart';

class SelectFirstAnimalScreen extends StatefulWidget {
  static const String routeTag = 'selectFirstAnimalScreenRoute';

  @override
  State<StatefulWidget> createState() {
    return _SelectFirstAnimalScreenState();
  }
}

class _SelectFirstAnimalScreenState extends State<SelectFirstAnimalScreen> {
  bool _checkConfiguration() => true;
  AudioPlayerService audioPlayerService;
  bool madeInitSound = false;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);
    if (_checkConfiguration() && madeInitSound == false) {
      Future.delayed(Duration.zero, () {
        madeInitSound = true;
        // userStateService.setlockScreen(true);
        audioPlayerService.tellIntroduction();
      });
    }
    Size size = MediaQuery.of(context).size;
    bool lockScreen = audioPlayerService.lockScreen;
    bool witchTalking = audioPlayerService.witchTalking;

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
              Stack(children: <Widget>[
                Positioned(
                  bottom: 20,
                  left: 0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[AnimalButtonList(animalsize: 150)]),
                ),
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
              ])
            ])));
  }
}
