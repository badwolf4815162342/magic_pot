import 'package:flutter/widgets.dart';
import 'package:magic_pot/screens/level/ingredient_draggable.dart';

class IngredientDraggableList extends StatefulWidget {
  final List<IngredientDraggable> currentDraggables;

  const IngredientDraggableList({Key key, this.currentDraggables})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IngredientDraggableListState();
  }
}

class _IngredientDraggableListState extends State<IngredientDraggableList> {
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
