import 'dart:async';

import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/archievement_buttons.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/custom_widget/blink_widget.dart';
import 'package:magic_pot/custom_widget/difficulty_button.dart';
import 'package:magic_pot/custom_widget/play_button.dart';
import 'package:magic_pot/logger.util.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  Difficulty difficulty = Difficulty.EASY;

  Image myImage;

  @override
  void initState() {
    super.initState();
    myImage = Image.asset(GlobalConfiguration().getString("menuscreen_path"));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    difficulty =
        Provider.of<UserModel>(context, listen: true).currentDifficulty;

    return Consumer<UserModel>(
      builder: (context, cart, child) {
        return Scaffold(
            body: BackgroundLayout(
                scene: LayoutBuilder(
                  builder: (context, constraints) => Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned(
                          bottom: double.parse(GlobalConfiguration()
                              .getString("play_button_distancd_bottom")),
                          right: double.parse(GlobalConfiguration()
                              .getString("play_button_distancd_right")),
                          child: PlayButton(
                            pushedName: ExplanationScreen.tag,
                            opacity: 0.9,
                            active: true,
                          )),
                      Positioned(
                        top: 0,
                        left: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Schwierigkeit?"),
                              DifficultyButton(
                                  buttonDifficulty: Difficulty.EASY,
                                  currentDifficulty: difficulty),
                              DifficultyButton(
                                  buttonDifficulty: Difficulty.MIDDLE,
                                  currentDifficulty: difficulty),
                              DifficultyButton(
                                  buttonDifficulty: Difficulty.HARD,
                                  currentDifficulty: difficulty),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 300,
                        left: 300,
                        child:
                            Center(child: ArchievementButtons(animalsize: 100)),
                      ),
                    ],
                  ),
                ),
                picUrl: GlobalConfiguration().getString("menuscreen_path")));
      },
    );
  }
}
