import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/ingredient.dart';

class IngredientDraggable extends StatelessWidget {
  IngredientDraggable({@required this.ingredient});
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Draggable(
        data: ingredient.name,
        child: Text(
          "${ingredient.picture}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 100,
          ),
        ),
        feedback: Text(
          "${ingredient.picture}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 120,
          ),
        ),
        childWhenDragging: Text(
          "${ingredient.picture}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 100,
          ),
        ),
      ),
    ]);
  }
}
