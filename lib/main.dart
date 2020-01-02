import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/animal_selector_button.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/models/animal.dart';

import 'package:magic_pot/models/user.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/level_screen.dart';
import 'package:magic_pot/screens/menu_screen.dart';
import 'package:magic_pot/screens/select_first_animal_screen.dart';
import 'package:provider/provider.dart';

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
            'levelScreenRoute': (context) => LevelScreen()
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MenuPage(),
        ));
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Animal animal = Provider.of<UserModel>(context).currentAnimal;
    print(animal);
    if (animal == null) {
      return SelectFirstAnimalScreen();
    } else {
      return MenuScreen();
    }
  }
}

class AnimalSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Routing & Navigation"),
        ),
        body: BackgroundLayout(
          scene: Container(
              width: MediaQuery.of(context).size.height / 2,
              child: ButtonsWithName()),
        ));
  }
}

class ButtonsWithName extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    print("createstate");
    // TODO: implement createState
    return _ButtonsWithNameState();
  }
}

class _ButtonsWithNameState extends State<ButtonsWithName> {
  List<AnimalSelectorButton> buttonsList = new List<AnimalSelectorButton>();

  List<Widget> _buildButtonsWithNames() {
    var animals = Provider.of<UserModel>(context).animals;
    print(animals);
    for (int i = 0; i < animals.length; i++) {
      buttonsList.add(new AnimalSelectorButton(animal: animals[i]));
    }
    return buttonsList;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        primary: false,
        crossAxisSpacing: 10,
        mainAxisSpacing: 0,
        crossAxisCount: 2,
        children: _buildButtonsWithNames());
  }
}
