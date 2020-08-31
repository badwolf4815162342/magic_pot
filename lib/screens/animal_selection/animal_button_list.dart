import 'package:flutter/widgets.dart';
import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/screens/animal_selection/animal_button.dart';

import '../../util/logger.util.dart';

class AnimalButtonList extends StatefulWidget {
  final double animalsize;

  const AnimalButtonList({Key key, this.animalsize}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnimalButtonListState();
  }
}

class _AnimalButtonListState extends State<AnimalButtonList> {
  List<AnimalButton> buttonsList = new List<AnimalButton>();
  List<Animal> animals = new List<Animal>();

  @override
  void initState() {
    _setAnimals();
    super.initState();
  }

  _setAnimals() async {
    animals = await DBApi.db.getUnselectedAnimals();
    setState(() {});
  }

  List<Widget> _buildButtonsWithNames() {
    final log = getLogger();
    log.d('ButtonsWithName: Animals ' + animals.toString());
    buttonsList = new List<AnimalButton>();
    for (int i = 0; i < animals.length; i++) {
      buttonsList
          .add(new AnimalButton(animal: animals[i], size: widget.animalsize));
    }
    return buttonsList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: _buildButtonsWithNames());
  }
}
