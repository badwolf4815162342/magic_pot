@immutable
import 'package:flutter/material.dart';

class Object {
  final int id;
  final String name;
  final String picture;
  final WordLevel level;

  Object(this.id, this.name, this.level, this.picture);
}

enum WordLevel { ONE, TWO, THREE, FOUR }
