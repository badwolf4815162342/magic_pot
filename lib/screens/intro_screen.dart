import 'package:flutter/material.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/logger.util.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/menu/menu_screen.dart';
import 'package:magic_pot/screens/animal_selection/select_first_animal_screen.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

// First screen with Learnig4Kids Logo and Play button to start
class IntroScreen extends StatelessWidget {
  final log = getLogger();

  bool areProvidersReady(UserStateService _userStateService, AudioPlayerService _audioPlayerService) {
    return _userStateService != null &&
        _userStateService.isIntializing == false &&
        _audioPlayerService != null &&
        _audioPlayerService.isIntializing == false;
  }

  @override
  Widget build(BuildContext context) {
    final AudioPlayerService audioPlayerService = Provider.of<AudioPlayerService>(context);
    final UserStateService userStateService = Provider.of<UserStateService>(context);

    // set initial device sizes
    SizeUtil.width = MediaQuery.of(context).size.width;
    SizeUtil.height = MediaQuery.of(context).size.height;

    if (areProvidersReady(userStateService, audioPlayerService)) {
      Animal animal = userStateService.currentAnimal;
      log.i('MenuPage:' + 'Animal=' + animal.toString());
      return Scaffold(
          body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/pics/intro_screen.jpg',
              width: SizeUtil.width,
              height: SizeUtil.height,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) => Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // CHANGE ANIMAL BUTTON
                Positioned(
                    left: SizeUtil.getDoubleByDeviceHorizontal(400),
                    top: SizeUtil.getDoubleByDeviceVertical(560),
                    child: Container(
                      child: RawMaterialButton(
                        child: Image.asset('assets/pics/reverse_blue.png',
                            height: SizeUtil.getDoubleByDeviceHorizontal(Constant.changeAnimalButtonSize),
                            width: SizeUtil.getDoubleByDeviceHorizontal(Constant.changeAnimalButtonSize),
                            fit: BoxFit.fitWidth),
                        onPressed: () {
                          //TODO(viviane): RESET EVERYTHING!!!
                        },
                      ),
                    )),
                Positioned(
                  bottom: Constant.playButtonDistanceBottom,
                  right: Constant.playButtonDistanceRight,
                  child: RawMaterialButton(
                    child: new Image.asset(
                      'assets/pics/play_blue.png',
                      width: SizeUtil.getDoubleByDeviceVertical(Constant.playButtonSize),
                      height: SizeUtil.getDoubleByDeviceHorizontal(Constant.playButtonSize),
                    ),
                    onPressed: () {
                      // decide to select initial animal when first opneing the app
                      if (animal == null) {
                        Navigator.pushNamed(context, SelectFirstAnimalScreen.routeTag);
                      } else {
                        // or go to menu when you already selected an animal last time
                        userStateService.setPlayAtNewestPosition();
                        Navigator.pushNamed(context, MenuScreen.routeTag);
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ));
    } else {
      return Center(
        child: new Image.asset(
          'assets/pics/intro_screen.jpg',
          width: SizeUtil.width,
          height: SizeUtil.height,
          fit: BoxFit.fill,
        ),
      );
    }
  }
}
