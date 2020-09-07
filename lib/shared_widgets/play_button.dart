import 'package:flutter/material.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/shared_widgets/blink_widget.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/shared_widgets/empty_placeholder.dart';
import 'package:provider/provider.dart';

// Play button to go to next scrren (blinking when sounds are over)
class PlayButton extends StatelessWidget {
  PlayButton({@required this.pushedName, @required this.size, @required this.active, this.animationDone = false});
  final String pushedName;
  final bool active;
  final bool animationDone;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (active) {
      return BlinkWidget(
        children: <Widget>[
          RawMaterialButton(
            child: DarkableImage(
              url: 'assets/pics/play_blue.png',
              width: size,
              height: size,
            ),
            onPressed: () {
              if (animationDone) {
                Provider.of<UserStateService>(context, listen: false).setLevelAnimatedFalse();
              }
              Navigator.pushNamed(context, pushedName);
            },
          ),
          RawMaterialButton(
            child: DarkableImage(
              url: 'assets/pics/play_blue_light.png',
              width: size,
              height: size,
            ),
            onPressed: () {
              if (animationDone) {
                Provider.of<UserStateService>(context, listen: false).setLevelAnimatedFalse();
              }
              Navigator.pushNamed(context, pushedName);
            },
          )
        ],
      );
    } else {
      return EmptyPlaceholder();
    }
  }
}
