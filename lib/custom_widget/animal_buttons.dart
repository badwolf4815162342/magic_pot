import 'package:flutter/widgets.dart';
import 'package:magic_pot/custom_widget/animal_selector_button.dart';
import 'package:magic_pot/models/user.dart';
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

  List<Widget> _buildButtonsWithNames() {
    var animals = Provider.of<UserModel>(context).animals;
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
