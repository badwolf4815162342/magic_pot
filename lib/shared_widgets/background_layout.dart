import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/shared_widgets/exit_button.dart';
import 'package:magic_pot/shared_widgets/selected_animal.dart';
import 'package:magic_pot/shared_widgets/witch.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

// The BackgroundLayout shows the left hand side third of the screen on level, explanation and select animal screeen. Here the witch and the animal are displayed always in the same way, the right and side 2/3 are inserted as a child witched 'scene'
class BackgroundLayout extends StatelessWidget {
  BackgroundLayout(
      {@required this.scene, @required this.picUrl, this.closeApp = false, this.animalSelectionBack = false});
  final Widget scene;
  final String picUrl;
  final bool closeApp;
  final bool animalSelectionBack;

  @override
  Widget build(BuildContext context) {
    AudioPlayerService audioPlayerService = Provider.of<AudioPlayerService>(context);

    var lockScreen = audioPlayerService.lockScreen;
    var witchTalking = audioPlayerService.witchTalking;
    return Stack(
      children: <Widget>[
        IgnorePointer(
            ignoring: lockScreen,
            child: Center(
              child: DarkableImage(
                url: picUrl,
                width: SizeUtil.width,
                height: SizeUtil.height,
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
                    // TODO(viviane): Should selecting x during the level stop all sound and be clickable even when the witch is talking?
                    Positioned(
                        left: SizeUtil.getDoubleByDeviceHorizontal(50),
                        top: SizeUtil.getDoubleByDeviceVertical(50),
                        child: Container(
                          child: ExitButton(
                            closeApp: closeApp,
                          ),
                        )),
                    // BASIC WITCH
                    Positioned(
                        right: SizeUtil.getDoubleByDeviceHorizontal(-10),
                        top: SizeUtil.getDoubleByDeviceVertical(100),
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Witch(
                                standartWitchText: false,
                                rotate: false,
                                talking: false,
                                size: Constant.backgroundLayoutWitchSize))),
                    // WITCH
                    witchTalking
                        ? Positioned(
                            right: SizeUtil.getDoubleByDeviceHorizontal(-10),
                            top: SizeUtil.getDoubleByDeviceVertical(100),
                            child: Witch(rotate: false, talking: true, size: Constant.backgroundLayoutWitchSize))
                        : Container(),

                    // ANIMAL
                    Positioned(
                        left: SizeUtil.getDoubleByDeviceHorizontal(140),
                        top: SizeUtil.getDoubleByDeviceVertical(560),
                        child: IgnorePointer(
                            ignoring: lockScreen, child: SelectedAnimal(size: Constant.backgroundLayoutAnimalSize))),
                    // CHANGE ANIMAL BUTTON
                    Positioned(
                        right: SizeUtil.getDoubleByDeviceHorizontal(270),
                        top: SizeUtil.getDoubleByDeviceVertical(580),
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                              width: 180,
                              height: 180,
                              child: RawMaterialButton(
                                child: DarkableImage(
                                  url: 'assets/pics/reverse_blue.png',
                                  width: SizeUtil.getDoubleByDeviceHorizontal(Constant.changeAnimalButtonSize),
                                ),
                                onPressed: () {
                                  if (animalSelectionBack) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pushNamed(context, "animalSelectionScreenRoute");
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
