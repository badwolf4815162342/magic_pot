import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class ExplanationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExplanationScreenState();
  }
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  Level currentLevel;

  static AudioCache player = AudioCache();

  @override
  Widget build(BuildContext context) {
    currentLevel = Provider.of<UserModel>(context, listen: false)
        .getLevelFromNumberAndDiff();
    if (currentLevel == null) {
      print("nulllevel");
    } else {
      print("currentlevel = ${currentLevel}");
    }

    var levelnum = 0;
    if (currentLevel == null) {
      levelnum = 1000;
    } else {
      levelnum = currentLevel.number;
    }

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
                  'Explanation .... ${levelnum}',
                  style: TextStyle(color: Colors.black),
                ),
                RaisedButton(
                  child: Text("Start Level"),
                  onPressed: () {
                    Navigator.pushNamed(context, "levelScreenRoute");
                  },
                ),
                // new Image(image: new AssetImage("gifs/2Mw3.gif")),
                new Image.asset(
                  "assets/gifs/2Mw3.gif",
                  height: 30.0,
                ),
              ])),
          picUrl: 'assets/pics/animal_selection.png'),
    );
  }
}
