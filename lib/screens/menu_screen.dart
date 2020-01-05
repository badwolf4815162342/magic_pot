import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, cart, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Routing & Navigation"),
            ),
            body: BackgroundLayout(
                scene: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Hi, wanna start?',
                      ),
                      RaisedButton(
                        child: Text("Start Game"),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, "explanationScreenRoute");
                        },
                      ),
                      RaisedButton(
                        child: Text("Select Animal"),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, "animalSelectionScreenRoute");
                        },
                      ),
                    ],
                  ),
                ),
                picUrl: 'assets/pics/animal_selection.png'));
      },
    );
  }
}
