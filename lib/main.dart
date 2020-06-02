import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/animal_selector_button.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:logger/logger.dart';
import 'package:magic_pot/logger.util.dart';

import 'package:magic_pot/models/user.dart';
import 'package:magic_pot/screens/animal_selection_screen.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/level_finished_screen.dart';
import 'package:magic_pot/screens/level_screen.dart';
import 'package:magic_pot/screens/menu_screen.dart';
import 'package:magic_pot/screens/select_first_animal_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'config/Config1.config.dart';

import 'dart:math' as math;

import 'logger.util.dart';

void main() async {
  //await GlobalConfiguration().loadFromAsset("app_settings");
  GlobalConfiguration().loadFromMap(appSettings);

  // print(int.parse(GlobalConfiguration().getString("key1")));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // CartModel is implemented as a ChangeNotifier, which calls for the use
          // of ChangeNotifierProvider. Moreover, CartModel depends
          // on CatalogModel, so a ProxyProvider is needed.
          ChangeNotifierProvider(builder: (context) => UserModel()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          routes: {
            'explanationScreenRoute': (context) => ExplanationScreen(),
            'animalSelectionScreenRoute': (context) => AnimalSelectionScreen(),
            'levelScreenRoute': (context) => LevelScreen(),
            'menuScreenRoute': (context) => MenuPage(),
            'introScreenRoute': (context) => IntroPage(),
            'levelFinishedRoute': (context) => LevelFinishedScreen(),
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: IntroPage(),
        ));
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final log = getLogger();
    Animal animal = Provider.of<UserModel>(context).currentAnimal;
    log.i('MenuPage:' + 'Animal=' + animal.toString());
    if (animal == null) {
      return SelectFirstAnimalScreen();
    } else {
      return MenuScreen();
    }
  }
}

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<UserModel>(builder: (context, cart, child) {
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
                      Navigator.push(
                        context,
                        SlideRightRoute(page: MenuPage()),
                      );
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

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
