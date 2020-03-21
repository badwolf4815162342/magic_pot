import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/animal_selector_button.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/models/animal.dart';

import 'package:magic_pot/models/user.dart';
import 'package:magic_pot/screens/animal_selection_screen.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/level_finished_screen.dart';
import 'package:magic_pot/screens/level_screen.dart';
import 'package:magic_pot/screens/menu_screen.dart';
import 'package:magic_pot/screens/select_first_animal_screen.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math; 

void main() => runApp(MyApp());

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
    Animal animal = Provider.of<UserModel>(context).currentAnimal;
    print('Menu');
    print(animal);
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
    return Consumer<UserModel>(
      builder: (context, cart, child) {
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
                children: <Widget>[
                  
                ],
              ),
            ),
            LayoutBuilder(builder: (context, constraints) =>
              Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned(
                    top: size.height - 100,
                    left: size.width - 200,
                    child: RawMaterialButton(
                      child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: new Image.asset(
                            'assets/pics/hand.png',
                            width: 200,
                            height: 50,
                          )),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, "menuScreenRoute");    
                        },
                      ),
                  ),
                ],
              ),
            )
          ],
        )
                        );
      }
    );
  }
}