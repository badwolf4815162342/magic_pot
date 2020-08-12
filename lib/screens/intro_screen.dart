import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:magic_pot/logger.util.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:magic_pot/screens/menu_screen.dart';
import 'package:magic_pot/screens/select_first_animal_screen.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final log = getLogger();
    Animal animal = Provider.of<ControllingProvider>(context).currentAnimal;
    log.i('MenuPage:' + 'Animal=' + animal.toString());
    return Consumer<ControllingProvider>(builder: (context, cart, child) {
      return Scaffold(
          body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/pics/intro_screen.png',
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
                  bottom: double.parse(GlobalConfiguration()
                      .getString("play_button_distancd_bottom")),
                  right: double.parse(GlobalConfiguration()
                      .getString("play_button_distancd_right")),
                  child: RawMaterialButton(
                    child: new Image.asset(
                      'assets/pics/play_blue.png',
                      width: double.parse(
                          GlobalConfiguration().getString("play_button_size")),
                      height: double.parse(
                          GlobalConfiguration().getString("play_button_size")),
                    ),
                    onPressed: () {
                      if (animal == null) {
                        Navigator.pushNamed(
                            context, SelectFirstAnimalScreen.routeTag);
                      } else {
                        Provider.of<ControllingProvider>(context)
                            .setPlayAtNewestPosition();
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
    });
  }
}
