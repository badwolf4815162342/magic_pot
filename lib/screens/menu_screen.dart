import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/custom_widget/archievement_buttons.dart';
import 'package:magic_pot/custom_widget/darkable_image.dart';
import 'package:magic_pot/custom_widget/empty_placeholder.dart';
import 'package:magic_pot/custom_widget/play_button.dart';
import 'package:magic_pot/custom_widget/exit_button.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  static const String routeTag = 'menuScreenRoute';

  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  Image myImage;
  AudioPlayerService audioPlayerService;

  bool madeInitSound = false;

  void initState() {
    super.initState();
    myImage = Image.asset(Constant.menuScreenPath);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);

    myImage = Image.asset(Constant.menuScreenPath);
    if (madeInitSound == false) {
      Future.delayed(Duration.zero, () async {
        madeInitSound = true;
        bool newArchievements = await DBApi.db.newArchievements();
        audioPlayerService.menuSound(newArchievements);
      });
    }
    var lockScreen = audioPlayerService.lockScreen;
    var allArchieved = Provider.of<UserStateService>(context).allArchieved;
    Size size = MediaQuery.of(context).size;
    var witchTalking = audioPlayerService.witchTalking;
    var animal = Provider.of<UserStateService>(context).currentAnimal;

    return Scaffold(
        body: IgnorePointer(
            ignoring: lockScreen,
            child: Stack(children: <Widget>[
              Center(
                child: DarkableImage(
                  url: Constant.menuScreenPath,
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.fill,
                ),
              ),
              Stack(children: <Widget>[
                // X BUTTON
                Positioned(
                    left: -40,
                    bottom: 580,
                    child: IgnorePointer(
                        ignoring: lockScreen,
                        child: Container(
                          width: 200,
                          height: 200,
                          child: ExitButton(
                            closeApp: true,
                          ),
                        ))),
                // PLAY
                Positioned(
                    bottom: Constant.playButtonDistanceBottom,
                    right: Constant.playButtonDistanceRight,
                    child: PlayButton(
                      pushedName: ExplanationScreen.routeTag,
                      active: (!lockScreen && !allArchieved),
                      animationDone: true,
                    )),
                // Archievements
                Positioned(
                  top: 230,
                  left: 740,
                  child: Center(child: ArchievementButtons(animalsize: 100)),
                ),
                // Stars
                Positioned(
                    top: 240,
                    left: 555,
                    height: 350,
                    width: 350,
                    child: Container(
                        child: FlareActor(
                      "assets/animation/stars.flr",
                      animation: "move",
                    ))),
                // BASIC WITCH
                Positioned(
                    bottom: 95,
                    right: 875,
                    child: FlatButton(
                      child: new Image.asset(
                        Constant.standartWitchIconPath,
                        height: 500,
                        width: 500,
                      ),
                      onPressed: () {
                        audioPlayerService.tellStandartWitchText();
                      },
                    )),
                // WITCH
                witchTalking
                    ? Positioned(
                        bottom: 95,
                        right: 875,
                        child: FlatButton(
                          child: new Image.asset(
                            Constant.talkingWitchIconPath,
                            height: 500,
                            width: 500,
                          ),
                          onPressed: () {
                            audioPlayerService.tellStandartWitchText();
                          },
                        ))
                    : Container(),
                // ANIMAL
                Positioned(
                    left: 500,
                    top: 475,
                    child: IgnorePointer(
                        ignoring: lockScreen,
                        child: Container(
                          child: RawMaterialButton(
                            child: (animal == null)
                                ? EmptyPlaceholder()
                                : DarkableImage(
                                    url: animal.picture, height: 170),
                            onPressed: () {
                              audioPlayerService
                                  .makeAnimalSound(animal.soundfile);
                            },
                          ),
                        ))),
                // CHANGE ANIMAL BUTTON
                Positioned(
                    left: 400,
                    top: 560,
                    child: IgnorePointer(
                        ignoring: lockScreen,
                        child: Container(
                          //width: 180,
                          //height: 180,
                          child: RawMaterialButton(
                            child: DarkableImage(
                                url: 'assets/pics/reverse_blue.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitWidth),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "animalSelectionScreenRoute");
                            },
                          ),
                        ))),
              ])
            ])));
  }
}
