import 'package:magic_pot/models/object.dart';

import '../logger.util.dart';

class Level {
  int number;
  int numberOfMinObjects;
  int numberOfRightObjectsInARow;
  Difficulty difficulty;
  WordLevel wordlevel;
  int numberOfObjectsToChooseFrom;
  String soundfile;
  String picBeforeUrl;
  String picAftereUrl;

  Level(
      this.number,
      this.numberOfMinObjects,
      this.numberOfRightObjectsInARow,
      this.difficulty,
      this.wordlevel,
      this.numberOfObjectsToChooseFrom,
      this.soundfile,
      this.picBeforeUrl,
      this.picAftereUrl);
}

enum Difficulty { EASY, MIDDLE, HARD }

class LevelHelper {
  static printLevelInfo(Level level) {
    final log = getLogger();
    if (level == null) {
      log.i('LevelHelper:' + 'No Level Info');
    } else {
      log.i('LevelHelper:' +
          "This Level needs ${level.numberOfRightObjectsInARow} right objects in a row to finish but min ${level.numberOfMinObjects} objects have to be tried. WORDLEVEL:${level.wordlevel},DIFFICULTY:${level.difficulty}");
    }
  }

  static getDifficultyText(Difficulty difficulty) {
    final log = getLogger();
    switch (difficulty) {
      case (Difficulty.HARD):
        return "🧪🧪🧪";
        break;
      case (Difficulty.MIDDLE):
        return "🧪🧪";
        break;
      case (Difficulty.EASY):
        return "🧪";
        break;
      default:
        {
          log.e('LevelHelper:' + 'No Difficulty found!!');
        }
    }
  }
}
