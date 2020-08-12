import 'package:flutter/widgets.dart';
import 'package:magic_pot/custom_widget/empty_placeholder.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:magic_pot/provider/db_provider.dart';
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
  List<ArchievementButton> buttonsListEasy = new List<ArchievementButton>();
  List<ArchievementButton> buttonsListMiddle = new List<ArchievementButton>();
  List<ArchievementButton> buttonsListHard = new List<ArchievementButton>();

  List<Level> listEasy = new List<Level>();
  List<Level> listMiddle = new List<Level>();
  List<Level> listHard = new List<Level>();

  @override
  void initState() {
    _setArchievements();
    super.initState();
  }

  _setArchievements() async {
    listEasy =
        await DBProvider.db.getLevelByDifficultyAndArchieved(Difficulty.EASY);
    listMiddle =
        await DBProvider.db.getLevelByDifficultyAndArchieved(Difficulty.MIDDLE);
    listHard =
        await DBProvider.db.getLevelByDifficultyAndArchieved(Difficulty.HARD);
    print('');
    setState(() {});
  }

  List<Widget> _buildButtonsWithNamesEasy() {
    final log = getLogger();
    //log.d('ArchievementButtons: Archieve ' + listEasy.toString());
    buttonsListEasy = new List<ArchievementButton>();

    for (int i = 0; i < listEasy.length; i++) {
      buttonsListEasy.add(new ArchievementButton(
        level: listEasy[i],
        size: widget.animalsize,
        animate: !listEasy[i].animated,
      ));
    }

    return buttonsListEasy;
  }

  List<Widget> _buildButtonsWithNamesMiddle() {
    final log = getLogger();
    //log.d('ArchievementButtons: Archieve ' + listMiddle.toString());
    buttonsListMiddle = new List<ArchievementButton>();
    for (int i = 0; i < listMiddle.length; i++) {
      buttonsListMiddle.add(new ArchievementButton(
        level: listMiddle[i],
        size: widget.animalsize,
        animate: !listMiddle[i].animated,
      ));
    }
    return buttonsListMiddle;
  }

  List<Widget> _buildButtonsWithNamesHard() {
    final log = getLogger();
    //log.d('ArchievementButtons: Archieve ' + listHard.toString());
    buttonsListHard = new List<ArchievementButton>();

    for (int i = 0; i < listHard.length; i++) {
      buttonsListHard.add(new ArchievementButton(
        level: listHard[i],
        size: widget.animalsize,
        animate: !listHard[i].animated,
      ));
    }
    return buttonsListHard;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: (widget.animalsize * 5),
        height: widget.animalsize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildButtonsWithNamesEasy().isEmpty
              ? [EmptyPlaceholder()]
              : _buildButtonsWithNamesEasy(),
        ),
      ),
      Container(
        height: 65,
        width: 0,
      ),
      Container(
        width: (widget.animalsize * 5),
        height: widget.animalsize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildButtonsWithNamesMiddle().isEmpty
              ? [EmptyPlaceholder()]
              : _buildButtonsWithNamesMiddle(),
        ),
      ),
      Container(
        height: 20,
        width: 0,
      ),
      Container(
        width: (widget.animalsize * 5),
        height: widget.animalsize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildButtonsWithNamesHard().isEmpty
              ? [EmptyPlaceholder()]
              : _buildButtonsWithNamesHard(),
        ),
      ),
    ]);
    //return Row(children: _buildButtonsWithNames());
  }
}
