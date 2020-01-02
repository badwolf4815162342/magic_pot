import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/object.dart';
import 'package:audioplayers/audio_cache.dart';

class ObjectDraggable extends StatelessWidget {
  ObjectDraggable({@required this.object});
  final Object object;

  static AudioCache player = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: object.name,
      child: Text(
        "${object.picture}",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 100,
        ),
      ),
      feedback: Text(
        "${object.picture}",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 120,
        ),
      ),
      childWhenDragging: Text(
        "${object.picture}",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 100,
        ),
      ),
    );
  }
}
