import 'package:flutter/widgets.dart';
import 'package:magic_pot/api/db.api.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/shared_widgets/empty_placeholder.dart';

import 'achievement_button.dart';

class AchievementButtonList extends StatefulWidget {
  final double animalwidth;
  final double animalheight;

  const AchievementButtonList({Key key, this.animalwidth, this.animalheight}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AchievementButtonListState();
  }
}

class _AchievementButtonListState extends State<AchievementButtonList> {
  List<AchievementButton> buttonsListEasy = new List<AchievementButton>();
  List<AchievementButton> buttonsListMiddle = new List<AchievementButton>();
  List<AchievementButton> buttonsListHard = new List<AchievementButton>();

  List<Level> listEasy = new List<Level>();
  List<Level> listMiddle = new List<Level>();
  List<Level> listHard = new List<Level>();

  @override
  void initState() {
    _setArchievements();
    super.initState();
  }

  _setArchievements() async {
    listEasy = await DBApi.db.getLevelByDifficultyAndArchieved(Difficulty.EASY);
    listMiddle = await DBApi.db.getLevelByDifficultyAndArchieved(Difficulty.MIDDLE);
    listHard = await DBApi.db.getLevelByDifficultyAndArchieved(Difficulty.HARD);
    setState(() {});
  }

  List<Widget> _buildButtonsWithNamesEasy() {
    buttonsListEasy = new List<AchievementButton>();

    for (int i = 0; i < listEasy.length; i++) {
      buttonsListEasy.add(new AchievementButton(
        level: listEasy[i],
        animalwidth: widget.animalwidth,
        animalheight: widget.animalheight,
        animate: !listEasy[i].animated,
      ));
    }

    return buttonsListEasy;
  }

  List<Widget> _buildButtonsWithNamesMiddle() {
    buttonsListMiddle = new List<AchievementButton>();
    for (int i = 0; i < listMiddle.length; i++) {
      buttonsListMiddle.add(new AchievementButton(
        level: listMiddle[i],
        animalwidth: widget.animalwidth,
        animalheight: widget.animalheight,
        animate: !listMiddle[i].animated,
      ));
    }
    return buttonsListMiddle;
  }

  List<Widget> _buildButtonsWithNamesHard() {
    buttonsListHard = new List<AchievementButton>();

    for (int i = 0; i < listHard.length; i++) {
      buttonsListHard.add(new AchievementButton(
        level: listHard[i],
        animalwidth: widget.animalwidth,
        animalheight: widget.animalheight,
        animate: !listHard[i].animated,
      ));
    }
    return buttonsListHard;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: (widget.animalwidth * 5),
        height: widget.animalwidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildButtonsWithNamesEasy().isEmpty ? [EmptyPlaceholder()] : _buildButtonsWithNamesEasy(),
        ),
      ),
      Container(
        height: 65,
        width: 0,
      ),
      Container(
        width: (widget.animalwidth * 5),
        height: widget.animalwidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildButtonsWithNamesMiddle().isEmpty ? [EmptyPlaceholder()] : _buildButtonsWithNamesMiddle(),
        ),
      ),
      Container(
        height: 20,
        width: 0,
      ),
      Container(
        width: (widget.animalwidth * 5),
        height: widget.animalwidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildButtonsWithNamesHard().isEmpty ? [EmptyPlaceholder()] : _buildButtonsWithNamesHard(),
        ),
      ),
    ]);
  }
}
