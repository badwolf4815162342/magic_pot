import 'dart:convert';

List<Ingredient> employeeFromJson(String str) =>
    List<Ingredient>.from(json.decode(str).map((x) => Ingredient.fromJson(x)));

String employeeToJson(List<Ingredient> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ingredient {
  final int id;
  final String name;
  final WordLevel level;
  final String picture;

  Ingredient({this.id, this.name, this.level, this.picture});

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json["id"],
        name: json["name"],
        level: toWordLevel(json["level"]),
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "level": level.toString(),
        "picture": picture,
      };

  static toWordLevel(String level) {
    switch (level) {
      case ('ONE'):
        return WordLevel.TWO;
        break;
      case ('TWO'):
        return WordLevel.TWO;
        break;
      case ('THREE'):
        return WordLevel.TWO;
        break;
      case ('FOUR'):
        return WordLevel.TWO;
        break;

      default:
        return WordLevel.ONE;
    }
  }

  static toWordLevelString(WordLevel level) {
    switch (level) {
      case (WordLevel.ONE):
        return 'ONE';
        break;
      case (WordLevel.TWO):
        return 'TWO';
        break;
      case (WordLevel.THREE):
        return 'THREE';
        break;
      case (WordLevel.FOUR):
        return 'FOUR';
        break;

      default:
        return WordLevel.ONE;
    }
  }
}

enum WordLevel { ONE, TWO, THREE, FOUR }
