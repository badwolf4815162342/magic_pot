import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/custom_widget/difficulty_button.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<MenuScreen> {
  Difficulty difficulty = Difficulty.EASY;

  @override
  Widget build(BuildContext context) {
    difficulty = Provider.of<UserModel>(context, listen: true).currentDifficulty;
    return Consumer<UserModel>(
      builder: (context, cart, child) {
        return Scaffold(
            body: BackgroundLayout(
                scene: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RawMaterialButton(
                      child: new Image.asset(
                          'assets/pics/arm_wand.png',
                          width: 400,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, "explanationScreenRoute");
                        },
                      ),
                      Text("Schwierigkeit?"),
                      DifficultyButton(buttonDifficulty: Difficulty.EASY, currentDifficulty: difficulty),
                      DifficultyButton(buttonDifficulty: Difficulty.MIDDLE, currentDifficulty: difficulty),
                      DifficultyButton(buttonDifficulty: Difficulty.HARD, currentDifficulty: difficulty),
                    ],
                  ),
                ),
                picUrl: 'assets/pics/menu_screen.png'));
      },
    );
  }
}
