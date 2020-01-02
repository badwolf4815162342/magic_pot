import 'package:magic_pot/models/object.dart';

class Level {
  int number;
  int numberOfMinObjects;
  int numberOfRightObjectsInARow;
  Difficulty difficulty;
  WordLevel wordlevel;
  int numberOfObjectsToChooseFrom;
  String soundfile;

  Level(
      this.number,
      this.numberOfMinObjects,
      this.numberOfRightObjectsInARow,
      this.difficulty,
      this.wordlevel,
      this.numberOfObjectsToChooseFrom,
      this.soundfile);
}

enum Difficulty { EASY, MIDDLE, HARD }

class LevelHelper {
  static printLevelInfo(Level level) {
    if (level == null) {
      print("No Level Info");
    } else {
      print(
          "This Level needs ${level.numberOfRightObjectsInARow} right objects in a row to finish but min ${level.numberOfMinObjects} objects have to be tried. WORDLEVEL:${level.wordlevel},DIFFICULTY:${level.difficulty}");
    }
  }
}
