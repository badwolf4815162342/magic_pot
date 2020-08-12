import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/archievement_buttons.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/custom_widget/empty_placeholder.dart';
import 'package:magic_pot/custom_widget/play_button.dart';
import 'package:magic_pot/custom_widget/quit_button.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:magic_pot/provider/db_provider.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

class MenuScreen extends StatefulWidget {
  static const String routeTag = 'menuScreenRoute';

  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  _checkConfiguration() async {
    bool newArchievements = await DBProvider.db.newArchievements();
    Future.delayed(Duration.zero, () {
      Provider.of<ControllingProvider>(context, listen: false)
          .menuSound(newArchievements);
    });
  }

  Image myImage;

  void initState() {
    super.initState();
    myImage = Image.asset(GlobalConfiguration().getString("menuscreen_path"));
    _checkConfiguration();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    var lockScreen = Provider.of<ControllingProvider>(context).lockScreen;
    var allArchieved = Provider.of<ControllingProvider>(context).allArchieved;
    Size size = MediaQuery.of(context).size;
    var witchIcon = Provider.of<ControllingProvider>(context).witchIcon;
    var animal = Provider.of<ControllingProvider>(context).currentAnimal;

    return Consumer<ControllingProvider>(
      builder: (context, cart, child) {
        return Scaffold(
            body: IgnorePointer(
                ignoring: lockScreen,
                child: Stack(children: <Widget>[
                  Center(
                    child: new Image.asset(
                      GlobalConfiguration().getString("menuscreen_path"),
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Stack(children: <Widget>[
                    // X BUTTON
                    Positioned(
                        left: -40,
                        bottom: 580,
                        child: IgnorePointer(
                            ignoring: lockScreen,
                            child: Container(
                              width: 200,
                              height: 200,
                              child: ExitButton(
                                closeApp: true,
                              ),
                            ))),
                    // PLAY
                    Positioned(
                        bottom: double.parse(GlobalConfiguration()
                            .getString("play_button_distancd_bottom")),
                        right: double.parse(GlobalConfiguration()
                            .getString("play_button_distancd_right")),
                        child: PlayButton(
                          pushedName: ExplanationScreen.routeTag,
                          active: (!lockScreen && !allArchieved),
                          animationDone: true,
                        )),
                    // Archievements
                    Positioned(
                      top: 230,
                      left: 740,
                      child:
                          Center(child: ArchievementButtons(animalsize: 100)),
                    ),
                    // Stars
                    Positioned(
                        top: 240,
                        left: 555,
                        height: 350,
                        width: 350,
                        child: Container(
                            child: FlareActor(
                          "assets/animation/stars.flr",
                          animation: "move",
                        ))),

                    // WITCH
                    Positioned(
                        bottom: 95,
                        right: 875,
                        child: FlatButton(
                          child: new Image.asset(
                            witchIcon,
                            height: 500,
                            width: 500,
                          ),
                          onPressed: () {
                            Provider.of<ControllingProvider>(context)
                                .tellStandartWitchText();
                          },
                        )),
                    // ANIMAL
                    Positioned(
                        left: 500,
                        top: 475,
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
                        left: 400,
                        top: 560,
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
                  ])
                ])));
      },
    );
  }
}
