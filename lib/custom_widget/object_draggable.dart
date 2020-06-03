import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/object.dart';

class ObjectDraggable extends StatelessWidget {
  ObjectDraggable({@required this.object});
  final Object object;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 40, width: 10),
      Draggable(
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
      ),
      SizedBox(height: 40, width: 10)
    ]);
  }
}
