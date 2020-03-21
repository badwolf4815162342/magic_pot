import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class DifficultyButton extends StatelessWidget {
  DifficultyButton({@required this.buttonDifficulty, this.currentDifficulty});
  final Difficulty buttonDifficulty;
  final Difficulty currentDifficulty;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
                        color: (currentDifficulty==buttonDifficulty) ? Colors.green : Colors.white,
                        child: Text(LevelHelper.getDifficultyText(buttonDifficulty)),
                        onPressed: () {
                          Provider.of<UserModel>(context, listen: false).setDifficulty(buttonDifficulty);
                        },
                      );
  }
}
