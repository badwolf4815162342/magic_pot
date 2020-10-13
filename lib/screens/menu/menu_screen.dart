import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/menu/achievement_button_list.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/shared_widgets/exit_button.dart';
import 'package:magic_pot/shared_widgets/play_button.dart';
import 'package:magic_pot/shared_widgets/selected_animal.dart';
import 'package:magic_pot/shared_widgets/witch.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

// Menu screen with talking witch, selected animal, x button to close the app, play button to play the next level and achievements in the cupboard to play old levels again
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
        audioPlayerService.menuSound();
      });
    }
    var lockScreen = audioPlayerService.lockScreen;
    var allArchieved = Provider.of<UserStateService>(context).allArchieved;

    var witchTalking = audioPlayerService.witchTalking;
    return Scaffold(
        body: IgnorePointer(
            ignoring: lockScreen,
            child: Stack(children: <Widget>[
              Center(
                child: DarkableImage(
                  url: Constant.menuScreenPath,
                  width: SizeUtil.width,
                  height: SizeUtil.height,
                  fit: BoxFit.fill,
                ),
              ),
              Stack(children: <Widget>[
                // X BUTTON
                Positioned(
                    left: SizeUtil.getDoubleByDeviceHorizontal(40),
                    top: SizeUtil.getDoubleByDeviceVertical(40),
                    child: IgnorePointer(
                        ignoring: lockScreen,
                        child: Container(
                          width: SizeUtil.getDoubleByDeviceHorizontal(
                              Constant.xButtonSize),
                          child: ExitButton(
                            closeApp: true,
                          ),
                        ))),
                // PLAY
                Positioned(
                    bottom: Constant.playButtonDistanceBottom,
                    right: Constant.playButtonDistanceRight,
                    child: PlayButton(
                      size: SizeUtil.getDoubleByDeviceVertical(
                          Constant.playButtonSize),
                      pushedName: ExplanationScreen.routeTag,
                      active: (!lockScreen && !allArchieved),
                      animationDone: true,
                    )),
                // Archievements
                Positioned(
                  top: SizeUtil.getDoubleByDeviceVertical(230),
                  left: SizeUtil.getDoubleByDeviceHorizontal(740),
                  child: Center(
                      child: AchievementButtonList(
                          animalwidth: SizeUtil.getDoubleByDeviceHorizontal(
                              Constant.achievementButtonSize),
                          animalheight: SizeUtil.getDoubleByDeviceHorizontal(
                              (Constant.achievementButtonSize - 6)))),
                ),
                // Stars
                Positioned(
                    top: SizeUtil.getDoubleByDeviceVertical(240),
                    left: SizeUtil.getDoubleByDeviceHorizontal(555),
                    height: 350,
                    width: SizeUtil.getDoubleByDeviceHorizontal(
                        Constant.starGifSize),
                    child: Container(
                        child: FlareActor(
                      "assets/animation/stars.flr",
                      animation: "move",
                    ))),
                // BASIC WITCH
                Positioned(
                    bottom: SizeUtil.getDoubleByDeviceVertical(95),
                    right: SizeUtil.getDoubleByDeviceHorizontal(875),
                    child: Witch(
                        standartWitchText: true,
                        rotate: false,
                        talking: false,
                        size: Constant.witchSize)),
                // WITCH
                witchTalking
                    ? Positioned(
                        bottom: SizeUtil.getDoubleByDeviceVertical(95),
                        right: SizeUtil.getDoubleByDeviceHorizontal(875),
                        child: Witch(
                            rotate: false,
                            talking: true,
                            size: Constant.witchSize))
                    : Container(),
                // ANIMAL
                Positioned(
                    left: SizeUtil.getDoubleByDeviceHorizontal(500),
                    top: SizeUtil.getDoubleByDeviceVertical(475),
                    child: IgnorePointer(
                        ignoring: lockScreen,
                        child: SelectedAnimal(size: Constant.menuAnimalSize))),
                // CHANGE ANIMAL BUTTON
                Positioned(
                    left: SizeUtil.getDoubleByDeviceHorizontal(400),
                    top: SizeUtil.getDoubleByDeviceVertical(560),
                    child: IgnorePointer(
                        ignoring: lockScreen,
                        child: Container(
                          child: RawMaterialButton(
                            child: DarkableImage(
                                url: 'assets/pics/reverse_blue.png',
                                width: SizeUtil.getDoubleByDeviceHorizontal(
                                    Constant.changeAnimalButtonSize),
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
