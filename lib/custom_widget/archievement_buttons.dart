import 'package:flutter/widgets.dart';
import 'package:magic_pot/custom_widget/animal_selector_button.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

import '../logger.util.dart';
import 'archievement_button.dart';

class ArchievementButtons extends StatefulWidget {
  final double animalsize;

  const ArchievementButtons({Key key, this.animalsize}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ArchievementButtonsState();
  }
}

class _ArchievementButtonsState extends State<ArchievementButtons> {
  List<ArchievementButton> buttonsList = new List<ArchievementButton>();

  List<Widget> _buildButtonsWithNames() {
    var archievements = Provider.of<UserModel>(context).archievements;
    final log = getLogger();
    log.d('ArchievementButtons: Archieve ' + archievements.toString());
    buttonsList = new List<ArchievementButton>();
    for (int i = 0; i < archievements.length; i++) {
      buttonsList.add(new ArchievementButton(
          level: archievements[i], size: widget.animalsize));
    }
    return buttonsList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: _buildButtonsWithNames());
  }
}
