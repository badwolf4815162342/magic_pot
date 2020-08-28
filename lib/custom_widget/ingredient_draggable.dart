import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/ingredient.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:provider/provider.dart';

class IngredientDraggable extends StatelessWidget {
  IngredientDraggable({@required this.ingredient});
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    AudioPlayerService audioPlayerService =
        Provider.of<AudioPlayerService>(context);
    var lockScreen = audioPlayerService.lockScreen;

    return Column(children: [
      Draggable(
        data: ingredient.name,
        child: ColorFiltered(
            colorFilter: lockScreen
                ? ColorFilter.matrix(
                    <double>[
                      0.45,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0.4,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0.4,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ],
                  )
                : ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.multiply,
                  ),
            child: Text(
              "${ingredient.picture}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 100,
              ),
            )),
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
