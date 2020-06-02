import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';
import 'package:global_configuration/global_configuration.dart';

class LevelFinishedScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LevelFinishedScreen();
  }
}

class _LevelFinishedScreen extends State<LevelFinishedScreen> {
  bool _checkConfiguration() => true;

  void initState() {
    super.initState();
    if (_checkConfiguration()) {
      Future.delayed(Duration.zero, () {
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserModel>(context, listen: false).tellLevelFinished();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, cart, child) {
        return Scaffold(
            body: BackgroundLayout(
                scene: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Hi, wanna start new?',
                      ),
                      RaisedButton(
                        child: Text("To Menu"),
                        onPressed: () {
                          Navigator.pushNamed(context, "menuScreenRoute");
                        },
                      ),
                    ],
                  ),
                ),
                picUrl: 'assets/pics/level_finished_screen.png'));
      },
    );
  }
}
