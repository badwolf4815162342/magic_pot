import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/logger.util.dart';

import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:magic_pot/screens/animal_selection_screen.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/intro_screen.dart';
import 'package:magic_pot/screens/level_finished_screen.dart';
import 'package:magic_pot/screens/level_screen.dart';
import 'package:magic_pot/screens/menu_screen.dart';
import 'package:magic_pot/screens/select_first_animal_screen.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';
import 'config/Config1.config.dart';

import 'logger.util.dart';

void main() async {
  //await GlobalConfiguration().loadFromAsset("app_settings");
  GlobalConfiguration().loadFromMap(appSettings);

  // print(int.parse(GlobalConfiguration().getString("key1")));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final log = getLogger();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // CartModel is implemented as a ChangeNotifier, which calls for the use
          // of ChangeNotifierProvider. Moreover, CartModel depends
          // on CatalogModel, so a ProxyProvider is needed.
          ChangeNotifierProvider(builder: (context) => ControllingProvider()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: IntroPage(),
          onGenerateRoute: (RouteSettings routeSettings) {
            log.d("Change Screen: To " + routeSettings.name);
            // Screen comes from above

            return new PageRouteBuilder<dynamic>(
                settings: routeSettings,
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  switch (routeSettings.name) {
                    case MenuScreen.routeTag:
                      return MenuScreen();
                    case AnimalSelectionScreen.routeTag:
                      return AnimalSelectionScreen();
                    case SelectFirstAnimalScreen.routeTag:
                      return SelectFirstAnimalScreen();
                    case ExplanationScreen.routeTag:
                      return ExplanationScreen();
                    case LevelScreen.routeTag:
                      return LevelScreen();
                    case LevelFinishedScreen.routeTag:
                      return LevelFinishedScreen();
                    default:
                      return null;
                  }
                },
                transitionDuration: const Duration(milliseconds: 2000),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return effectMap[PageTransitionType.rippleMiddle](
                      Curves.linear, animation, secondaryAnimation, child);
                });
          },
        ));
  }
}

class MenuPage extends StatelessWidget {
  static const String routeTag = 'menuPageRoute';
  @override
  Widget build(BuildContext context) {
    final log = getLogger();
    Animal animal = Provider.of<ControllingProvider>(context).currentAnimal;
    log.i('MenuPage:' + 'Animal=' + animal.toString());
    if (animal == null) {
      return SelectFirstAnimalScreen();
    } else {
      return MenuScreen();
    }
  }
}
