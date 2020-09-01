import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/menu/achievement_button_list.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/shared_widgets/empty_placeholder.dart';
import 'package:magic_pot/shared_widgets/exit_button.dart';
import 'package:magic_pot/shared_widgets/play_button.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
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
    print(
        'Size: ${size.width} bottom ${SizeUtil.getDoubleByDeviceVertical(size.height, 580)}');

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
                    left: SizeUtil.getDoubleByDeviceHorizontal(size.width, -40),
                    bottom:
                        SizeUtil.getDoubleByDeviceVertical(size.height, 580),
                    child: IgnorePointer(
                        ignoring: lockScreen,
                        child: Container(
                          width: SizeUtil.getDoubleByDeviceHorizontal(
                              size.width, Constant.xButtonSize),
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
                          size.height, Constant.playButtonSize),
                      pushedName: ExplanationScreen.routeTag,
                      active: (!lockScreen && !allArchieved),
                      animationDone: true,
                    )),
                // Archievements
                Positioned(
                  top: SizeUtil.getDoubleByDeviceVertical(size.height, 230),
                  left: SizeUtil.getDoubleByDeviceHorizontal(size.width, 740),
                  child: Center(
                      child: AchievementButtonList(
                          animalwidth: SizeUtil.getDoubleByDeviceHorizontal(
                              size.width, Constant.achievementButtonSize),
                          animalheight: SizeUtil.getDoubleByDeviceHorizontal(
                              size.width,
                              (Constant.achievementButtonSize - 6)))),
                ),
                // Stars
                Positioned(
                    top: SizeUtil.getDoubleByDeviceVertical(size.height, 240),
                    left: SizeUtil.getDoubleByDeviceHorizontal(size.width, 555),
                    height: 350,
                    width: SizeUtil.getDoubleByDeviceHorizontal(
                        size.width, Constant.starGifSize),
                    child: Container(
                        child: FlareActor(
                      "assets/animation/stars.flr",
                      animation: "move",
                    ))),
                // BASIC WITCH
                Positioned(
                    bottom: SizeUtil.getDoubleByDeviceVertical(size.height, 95),
                    right:
                        SizeUtil.getDoubleByDeviceHorizontal(size.width, 875),
                    child: Witch(
                        image: Constant.standartWitchIconPath, size: size)),
                // WITCH
                witchTalking
                    ? Positioned(
                        bottom:
                            SizeUtil.getDoubleByDeviceVertical(size.height, 95),
                        right: SizeUtil.getDoubleByDeviceHorizontal(
                            size.width, 875),
                        child: Witch(
                            image: Constant.talkingWitchIconPath, size: size))
                    : Container(),

                // ANIMAL
                Positioned(
                    left: SizeUtil.getDoubleByDeviceHorizontal(size.width, 500),
                    top: SizeUtil.getDoubleByDeviceVertical(size.height, 475),
                    child: IgnorePointer(
                        ignoring: lockScreen,
                        child: Container(
                          child: RawMaterialButton(
                            child: (animal == null)
                                ? EmptyPlaceholder()
                                : DarkableImage(
                                    url: animal.picture,
                                    height: SizeUtil.getDoubleByDeviceVertical(
                                        size.height, Constant.menuAnimalSize)),
                            onPressed: () {
                              audioPlayerService
                                  .makeAnimalSound(animal.soundfile);
                            },
                          ),
                        ))),
                // CHANGE ANIMAL BUTTON
                Positioned(
                    left: SizeUtil.getDoubleByDeviceHorizontal(size.width, 400),
                    top: SizeUtil.getDoubleByDeviceVertical(size.height, 560),
                    child: IgnorePointer(
                        ignoring: lockScreen,
                        child: Container(
                          child: RawMaterialButton(
                            child: DarkableImage(
                                url: 'assets/pics/reverse_blue.png',
                                width: SizeUtil.getDoubleByDeviceHorizontal(
                                    size.width,
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

class Witch extends StatelessWidget {
  const Witch({
    Key key,
    @required this.size,
    @required this.image,
  }) : super(key: key);

  final Size size;
  final String image;

  @override
  Widget build(BuildContext context) {
    AudioPlayerService audioPlayerService =
        Provider.of<AudioPlayerService>(context);

    return FlatButton(
      child: new Image.asset(
        image,
        height:
            SizeUtil.getDoubleByDeviceVertical(size.height, Constant.witchSize),
        width: SizeUtil.getDoubleByDeviceHorizontal(
            size.width, Constant.witchSize),
      ),
      onPressed: () {
        audioPlayerService.tellStandartWitchText();
      },
    );
  }
}
