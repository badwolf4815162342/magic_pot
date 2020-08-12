import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/empty_placeholder.dart';
import 'package:magic_pot/custom_widget/quit_button.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class BackgroundLayout extends StatelessWidget {
  BackgroundLayout(
      {@required this.scene,
      @required this.picUrl,
      this.closeApp = false,
      this.animalSelectionBack = false});
  final Widget scene;
  final String picUrl;
  final bool closeApp;
  final bool animalSelectionBack;

  @override
  Widget build(BuildContext context) {
    var animal = Provider.of<ControllingProvider>(context).currentAnimal;
    var lockScreen = Provider.of<ControllingProvider>(context).lockScreen;
    var witchIcon = Provider.of<ControllingProvider>(context).witchIcon;
    var pic;
    if (animal == null) {
      pic = "Nothing";
    } else {
      pic = animal.picture;
    }
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
                        right: 270,
                        bottom: 580,
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                              width: 200,
                              height: 200,
                              child: ExitButton(
                                closeApp: closeApp,
                              ),
                            ))),
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
                                    Provider.of<ControllingProvider>(context)
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
                              child: RawMaterialButton(
                                child: (animal == null)
                                    ? EmptyPlaceholder()
                                    : new Image.asset(
                                        animal.picture,
                                      ),
                                onPressed: () {
                                  Provider.of<ControllingProvider>(context,
                                          listen: false)
                                      .makeAnimalSound(animal.soundfile);
                                },
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
                                  if (animalSelectionBack) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pushNamed(
                                        context, "animalSelectionScreenRoute");
                                  }
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
