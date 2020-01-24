import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/main.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class SelectFirstAnimalScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectFirstAnimalScreenState();
  }
}

class _SelectFirstAnimalScreenState extends State<SelectFirstAnimalScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<UserModel>(
      builder: (context, cart, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Routing & Navigation"),
            ),
            body: IgnorePointer(
                ignoring: false,
                child: Stack(children: <Widget>[
                  Center(
                    child: new Image.asset(
                      'assets/pics/animal_selection.png',
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Center(child: ButtonsWithName())
                ])));
      },
    );
  }
}
