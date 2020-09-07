import 'package:flutter/material.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/screens/animal_selection/animal_button_list.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/shared_widgets/witch.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

// Screen to select initial animal
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
        audioPlayerService.tellIntroduction();
      });
    }
    bool lockScreen = audioPlayerService.lockScreen;
    bool witchTalking = audioPlayerService.witchTalking;

    return Scaffold(
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
              Stack(children: <Widget>[
                Positioned(
                  bottom: SizeUtil.getDoubleByDeviceVertical(20),
                  left: 0,
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                    AnimalButtonList(animalsize: SizeUtil.getDoubleByDeviceHorizontal(Constant.animalSize))
                  ]),
                ),
                // BASIC WITCH
                Positioned(
                    bottom: 0,
                    left: SizeUtil.getDoubleByDeviceHorizontal(800),
                    child: Witch(rotate: true, talking: false, size: Constant.witchSize)),
                // WITCH
                witchTalking
                    ? Positioned(
                        bottom: SizeUtil.getDoubleByDeviceVertical(0),
                        left: SizeUtil.getDoubleByDeviceHorizontal(800),
                        child: Witch(rotate: true, talking: true, size: Constant.witchSize))
                    : Container(),
              ])
            ])));
  }
}
