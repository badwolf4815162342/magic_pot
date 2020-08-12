@immutable
import 'package:flutter/material.dart';

class Animal {
  int id;
  String name;
  String picture;
  String soundfile;
  bool isCurrent;

  Animal({this.id, this.name, this.picture, this.soundfile, this.isCurrent});

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
        id: json["id"],
        name: json["name"],
        picture: json["picture"],
        soundfile: json["soundfile"],
        isCurrent: json["is_current"] == 1 ? true : false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "picture": picture,
        "soundfile": soundfile,
        "is_current": isCurrent ? 1 : 0,
      };
}
