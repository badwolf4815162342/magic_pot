import 'package:flutter/material.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'back_to_menu_button.dart';

class BackgroundLayout extends StatelessWidget {
  BackgroundLayout({@required this.scene, @required this.picUrl});
  final Widget scene;
  final String picUrl;

  @override
  Widget build(BuildContext context) {
    var animal = Provider.of<UserModel>(context).currentAnimal;
    var lockScreen = Provider.of<UserModel>(context).lockScreen;
    var witchIcon = Provider.of<UserModel>(context).witchIcon;
    var pic;
    if (animal == null) {
      pic = "Nothing";
    } else {
      pic = animal.picture;
    }
    const double iconSize = 50;
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        IgnorePointer(
            ignoring: lockScreen,
            child: Center(
              child: new Image.asset(
                picUrl,
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
            )),
        Center(
            child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Stack(
                  children: <Widget>[
                    // X BUTTON
                    Positioned(
                        left: 270,
                        bottom: 570,
                        child: Container(
                          width: 200,
                          height: 200,
                          child: BackToMenuButton(),
                        )),
                    // WITCH
                    Positioned(
                        right: 10,
                        top: 100,
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                                width: 450,
                                height: 450,
                                child: FlatButton(
                                  child: new Image.asset(
                                    witchIcon,
                                  ),
                                  onPressed: () {
                                    Provider.of<UserModel>(context)
                                        .playWitchText();
                                  },
                                )))),
                    // ANIMAL
                    Positioned(
                        left: 140,
                        top: 550,
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                              width: 180,
                              height: 180,
                              child: new Image.asset(
                                animal.picture,
                              ),
                            ))),
                    // CHANGE ANIMAL BUTTON
                    Positioned(
                        right: 270,
                        top: 580,
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                              width: 180,
                              height: 180,
                              child: RawMaterialButton(
                                child: new Image.asset(
                                  'assets/pics/reverse_blue.png',
                                  width: 100,
                                  height: 100,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "animalSelectionScreenRoute");
                                },
                              ),
                            ))),
                  ],
                )),
            // SCENE (RIGHT 2/3)
            Expanded(
              child: IgnorePointer(ignoring: lockScreen, child: scene),
              flex: 2,
            ),
          ],
        )),
      ],
    );
  }
}
