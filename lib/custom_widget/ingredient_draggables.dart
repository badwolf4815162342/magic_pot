import 'package:flutter/widgets.dart';
import 'package:magic_pot/custom_widget/ingredient_draggable.dart';

class IngredientDraggables extends StatefulWidget {
  final List<IngredientDraggable> currentDraggables;

  const IngredientDraggables({Key key, this.currentDraggables}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IngredientDraggablesState();
  }
}

class _IngredientDraggablesState extends State<IngredientDraggables> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 570,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.currentDraggables,
        ));
  }
}
