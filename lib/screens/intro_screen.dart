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

class IntroScreen extends StatelessWidget {
  final log = getLogger();

  bool areProvidersReady(UserStateService _userStateService,
      AudioPlayerService _audioPlayerService) {
    return _userStateService != null &&
        _userStateService.isIntializing == false &&
        _audioPlayerService != null &&
        _audioPlayerService.isIntializing == false;
  }

  @override
  Widget build(BuildContext context) {
    final AudioPlayerService audioPlayerService =
        Provider.of<AudioPlayerService>(context);
    final UserStateService userStateService =
        Provider.of<UserStateService>(context);
    Size size = MediaQuery.of(context).size;

    if (areProvidersReady(userStateService, audioPlayerService)) {
      Animal animal = userStateService.currentAnimal;
      log.i('MenuPage:' + 'Animal=' + animal.toString());
      return Scaffold(
          body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/pics/intro_screen.jpg',
              width: size.width,
              height: size.height,
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
                Positioned(
                  bottom: Constant.playButtonDistanceBottom,
                  right: Constant.playButtonDistanceRight,
                  child: RawMaterialButton(
                    child: new Image.asset(
                      'assets/pics/play_blue.png',
                      width: SizeUtil.getDoubleByDeviceVertical(
                          size.height, Constant.playButtonSize),
                      height: SizeUtil.getDoubleByDeviceHorizontal(
                          size.width, Constant.playButtonSize),
                    ),
                    onPressed: () {
                      if (animal == null) {
                        Navigator.pushNamed(
                            context, SelectFirstAnimalScreen.routeTag);
                      } else {
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
          width: size.width,
          height: size.height,
          fit: BoxFit.fill,
        ),
      );
    }
  }
}
