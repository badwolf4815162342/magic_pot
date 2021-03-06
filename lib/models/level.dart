import 'package:magic_pot/models/ingredient.dart';

import '../util/logger.util.dart';

// Each level represents one potion to mix (4 potions result in one complete animal transformation). In total there are 3 animal transormations
class Level {
  int id;
  int number;
  int numberOfMinObjects;
  // Number of correct objects in a row to get to the next level (potion)
  int numberOfRightObjectsInARow;
  Difficulty difficulty;
  WordLevel wordlevel;
  int numberOfObjectsToChooseFrom;
  String soundfile;
  // transformation image of the animal before this level is finished
  String picBeforeUrl;
  // transformation image of the animal after this level is finished
  String picAftereUrl;
  // Variable that shows wether its the last trnsformation or not (this is called the 5th/10th/15th level and does not contain a potion mixing process, just the last transformation step of each animal)
  bool finalLevel;
  bool achievement;
  bool animated;

  Level(
      {this.id,
      this.number,
      this.numberOfMinObjects,
      this.numberOfRightObjectsInARow,
      this.difficulty,
      this.wordlevel,
      this.numberOfObjectsToChooseFrom,
      this.soundfile,
      this.picBeforeUrl,
      this.picAftereUrl,
      this.finalLevel,
      this.achievement,
      this.animated});

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"],
        number: json["number"],
        numberOfMinObjects: json["number_of_min_objects"],
        numberOfRightObjectsInARow: json["number_of_right_objects_in_a_row"],
        difficulty: toDifficulty(json["difficulty"]),
        wordlevel: Ingredient.toWordLevel(json["wordlevel"]),
        numberOfObjectsToChooseFrom: json["number_of_objects_to_choose_from"],
        soundfile: json["soundfile"],
        picBeforeUrl: (json["pic_before_url"]),
        picAftereUrl: json["pic_after_url"],
        finalLevel: json["final_level"] == 1 ? true : false,
        achievement: json["achievement"] == 1 ? true : false,
        animated: json["animated"] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "number_of_min_objects": numberOfMinObjects,
        "number_of_right_objects_in_a_row": numberOfRightObjectsInARow,
        "difficulty": toDifficultyString(difficulty),
        "wordlevel": Ingredient.toWordLevelString(wordlevel),
        "number_of_objects_to_choose_from": numberOfObjectsToChooseFrom,
        "soundfile": soundfile,
        "pic_before_url": picBeforeUrl,
        "pic_after_url": picAftereUrl,
        "final_level": finalLevel,
        "achievement": achievement,
        "animated": animated,
      };

  static toDifficulty(String str) {
    switch (str) {
      case ('EASY'):
        return Difficulty.EASY;
        break;
      case ('MIDDLE'):
        return Difficulty.MIDDLE;
        break;
      case ('HARD'):
        return Difficulty.HARD;
        break;
      default:
        throw ("toDifficulty arbitrary error " + str);
    }
  }

// After the maximum an false ingredients in a row the ingredient selection is changed to not find the correct ingredient by trial and error
  int getMaxFaults() {
    if (this.numberOfObjectsToChooseFrom <= 2) {
      return 1;
    } else {
      return 2;
    }
  }

  static toDifficultyString(Difficulty difficulty) {
    switch (difficulty) {
      case (Difficulty.EASY):
        return 'EASY';
        break;
      case (Difficulty.MIDDLE):
        return 'MIDDLE';
        break;
      case (Difficulty.HARD):
        return 'HARD';
        break;
      default:
        {
          //log.e('LevelHelper:' + 'No Difficulty found!!');
          throw ("toDifficultyString arbitrary error " + difficulty.toString());
        }
    }
  }
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

  static getNextDifficulty(Difficulty difficulty) {
    final log = getLogger();
    switch (difficulty) {
      case (Difficulty.HARD):
        return Difficulty.HARD;
        break;
      case (Difficulty.MIDDLE):
        return Difficulty.HARD;
        break;
      case (Difficulty.EASY):
        return Difficulty.MIDDLE;
        break;
      default:
        {
          log.e('LevelHelper:' + 'No Difficulty found!!');
        }
    }
  }
}
