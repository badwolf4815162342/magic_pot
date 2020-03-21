
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/custom_widget/animal_buttons.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class AnimalSelectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimalSelectionScreen();
  }
}

class _AnimalSelectionScreen extends State<AnimalSelectionScreen> {

  bool _checkConfiguration() => true;

  void initState() {
    super.initState();
    if (_checkConfiguration()) {
      Future.delayed(Duration.zero,() { // SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserModel>(context, listen: false).makeSound('audio/waehle_dein_tier.wav');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundLayout(
            scene: ButtonsWithName(animalsize: 100),
            picUrl: 'assets/pics/animal_selection.png'));
  }
}
