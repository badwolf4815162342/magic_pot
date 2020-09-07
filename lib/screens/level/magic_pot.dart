import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/provider/level_state.service.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';

// Magic Pot that can move and show that ingredient was correct or incorrect
class MagicPot extends StatelessWidget {
  const MagicPot({
    Key key,
    @required this.levelStateService,
    @required this.callback,
    @required this.size,
  }) : super(key: key);

  final Function callback;
  final LevelStateService levelStateService;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShakeAnimatedWidget(
      enabled: levelStateService.shaking,
      duration: Duration(milliseconds: levelStateService.millismovement),
      shakeAngle: Rotation.deg(z: levelStateService.angleMovement),
      curve: Curves.linear,
      child: DragTarget(
        builder: (context, List<String> strings, unacceptedObjectList) {
          return Center(
            child: DarkableImage(
              url: levelStateService.potImage,
              width: size,
              height: size,
            ),
          );
        },
        onWillAccept: (data) {
          return true;
        },
        onAccept: (data) {
          callback(data);
        },
      ),
    );
  }
}
