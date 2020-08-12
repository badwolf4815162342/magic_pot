import 'package:flutter/widgets.dart';
import 'package:magic_pot/custom_widget/animal_selector_button.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:magic_pot/provider/db_provider.dart';
import 'package:provider/provider.dart';

import '../logger.util.dart';

class ButtonsWithName extends StatefulWidget {
  final double animalsize;

  const ButtonsWithName({Key key, this.animalsize}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ButtonsWithNameState();
  }
}

class _ButtonsWithNameState extends State<ButtonsWithName> {
  List<AnimalSelectorButton> buttonsList = new List<AnimalSelectorButton>();
  List<Animal> animals = new List<Animal>();

  @override
  void initState() {
    _setAnimals();
    super.initState();
  }

  _setAnimals() async {
    animals = await DBProvider.db.getUnselectedAnimals();
    setState(() {});
  }

  List<Widget> _buildButtonsWithNames() {
    final log = getLogger();
    log.d('ButtonsWithName: Animals ' + animals.toString());
    buttonsList = new List<AnimalSelectorButton>();
    for (int i = 0; i < animals.length; i++) {
      buttonsList.add(new AnimalSelectorButton(
          animal: animals[i], size: widget.animalsize));
    }
    return buttonsList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: _buildButtonsWithNames());
  }
}
