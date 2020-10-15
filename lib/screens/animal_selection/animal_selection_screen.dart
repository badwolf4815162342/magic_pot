import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/screens/animal_selection/animal_button_list.dart';
import 'package:magic_pot/shared_widgets/background_layout.dart';
import 'package:provider/provider.dart';

// Screen to change currently selected helping animal
class AnimalSelectionScreen extends StatefulWidget {
  static const String routeTag = 'animalSelectionScreenRoute';
  @override
  State<StatefulWidget> createState() {
    return _AnimalSelectionScreen();
  }
}

class _AnimalSelectionScreen extends State<AnimalSelectionScreen> {
  AudioPlayerService audioPlayerService;
  bool madeInitSound = false;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);
    if (madeInitSound == false) {
      madeInitSound = true;
      audioPlayerService.tellChooseAnimal();
    }
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: BackgroundLayout(
          scene:
              Stack(children: <Widget>[Positioned(bottom: 10, right: 120, child: AnimalButtonList(animalsize: 150))]),
          picUrl: 'assets/pics/animal_change.png',
          animalSelectionBack: true,
        )));
  }
}
