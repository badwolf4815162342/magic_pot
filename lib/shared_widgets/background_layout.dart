import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/shared_widgets/empty_placeholder.dart';
import 'package:magic_pot/shared_widgets/exit_button.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

class BackgroundLayout extends StatelessWidget {
  BackgroundLayout(
      {@required this.scene,
      @required this.picUrl,
      this.closeApp = false,
      this.animalSelectionBack = false});
  final Widget scene;
  final String picUrl;
  final bool closeApp;
  final bool animalSelectionBack;
  AudioPlayerService audioPlayerService;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);

    var animal = Provider.of<UserStateService>(context).currentAnimal;
    var lockScreen = audioPlayerService.lockScreen;
    var witchTalking = audioPlayerService.witchTalking;
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        IgnorePointer(
            ignoring: lockScreen,
            child: Center(
              child: DarkableImage(
                url: picUrl,
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
            )),
        Center(
            child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Stack(
                  children: <Widget>[
                    // X BUTTON
                    Positioned(
                        right: SizeUtil.getDoubleByDeviceHorizontal(
                            size.width, 270),
                        bottom: SizeUtil.getDoubleByDeviceVertical(
                            size.height, 580),
                        child: Container(
                          child: ExitButton(
                            closeApp: closeApp,
                          ),
                        )),
                    // BASIC WITCH
                    Positioned(
                        right: SizeUtil.getDoubleByDeviceHorizontal(
                            size.width, -10),
                        top: SizeUtil.getDoubleByDeviceVertical(
                            size.height, 100),
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: FlatButton(
                              child: new Image.asset(
                                Constant.standartWitchIconPath,
                                height: SizeUtil.getDoubleByDeviceVertical(
                                    size.height,
                                    Constant.backgroundLayoutWitchSize),
                                width: SizeUtil.getDoubleByDeviceHorizontal(
                                    size.width,
                                    Constant.backgroundLayoutWitchSize),
                              ),
                              onPressed: () {
                                audioPlayerService.playWitchText();
                              },
                            ))),
                    // WITCH
                    witchTalking
                        ? Positioned(
                            right: SizeUtil.getDoubleByDeviceHorizontal(
                                size.width, -10),
                            top: SizeUtil.getDoubleByDeviceVertical(
                                size.height, 100),
                            child: FlatButton(
                              child: new Image.asset(
                                Constant.talkingWitchIconPath,
                                height: SizeUtil.getDoubleByDeviceVertical(
                                    size.height,
                                    Constant.backgroundLayoutWitchSize),
                                width: SizeUtil.getDoubleByDeviceHorizontal(
                                    size.width,
                                    Constant.backgroundLayoutWitchSize),
                              ),
                              onPressed: () {},
                            ))
                        : Container(),
                    // ANIMAL
                    Positioned(
                        left: SizeUtil.getDoubleByDeviceHorizontal(
                            size.width, 140),
                        top: SizeUtil.getDoubleByDeviceVertical(
                            size.height, 560),
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                              child: RawMaterialButton(
                                child: (animal == null)
                                    ? EmptyPlaceholder()
                                    : DarkableImage(
                                        url: animal.picture,
                                        height:
                                            SizeUtil.getDoubleByDeviceVertical(
                                                size.height,
                                                Constant
                                                    .backgroundLayoutAnimalSize),
                                      ),
                                onPressed: () {
                                  audioPlayerService
                                      .makeAnimalSound(animal.soundfile);
                                },
                              ),
                            ))),
                    // CHANGE ANIMAL BUTTON
                    Positioned(
                        right: SizeUtil.getDoubleByDeviceHorizontal(
                            size.width, 270),
                        top: SizeUtil.getDoubleByDeviceVertical(
                            size.height, 580),
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                              width: 180,
                              height: 180,
                              child: RawMaterialButton(
                                child: DarkableImage(
                                  url: 'assets/pics/reverse_blue.png',
                                  width: SizeUtil.getDoubleByDeviceHorizontal(
                                      size.width,
                                      Constant.changeAnimalButtonSize),
                                ),
                                onPressed: () {
                                  if (animalSelectionBack) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pushNamed(
                                        context, "animalSelectionScreenRoute");
                                  }
                                },
                              ),
                            ))),
                  ],
                )),
            // SCENE (RIGHT 2/3)
            Expanded(
              child: IgnorePointer(ignoring: lockScreen, child: scene),
              flex: 2,
            ),
          ],
        )),
      ],
    );
  }
}
