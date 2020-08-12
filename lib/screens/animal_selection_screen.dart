import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/custom_widget/animal_buttons.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:provider/provider.dart';

class AnimalSelectionScreen extends StatefulWidget {
  static const String routeTag = 'animalSelectionScreenRoute';
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
      Future.delayed(Duration.zero, () {
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<ControllingProvider>(context, listen: false)
            .tellChooseAnimal();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundLayout(
      scene: Stack(children: <Widget>[
        Positioned(
            bottom: 10, right: 120, child: ButtonsWithName(animalsize: 150))
      ]),
      picUrl: 'assets/pics/animal_change.png',
      animalSelectionBack: true,
    ));
  }
}
