import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:magic_pot/custom_widget/blink_widget.dart';
import 'package:magic_pot/custom_widget/darkable_image.dart';
import 'package:magic_pot/custom_widget/empty_placeholder.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:provider/provider.dart';

class PlayButton extends StatelessWidget {
  PlayButton(
      {@required this.pushedName,
      @required this.active,
      this.animationDone = false});
  final String pushedName;
  final bool active;
  final bool animationDone;

  @override
  Widget build(BuildContext context) {
    if (active) {
      return BlinkWidget(
        children: <Widget>[
          RawMaterialButton(
            child: DarkableImage(
              url: 'assets/pics/play_blue.png',
              width: Constant.playButtonSize,
              height: Constant.playButtonSize,
            ),
            onPressed: () {
              if (animationDone) {
                Provider.of<UserStateService>(context, listen: false)
                    .setLevelAnimatedFalse();
              }
              Navigator.pushNamed(context, pushedName);
            },
          ),
          RawMaterialButton(
            child: DarkableImage(
              url: 'assets/pics/play_blue_light.png',
              width: Constant.playButtonSize,
              height: Constant.playButtonSize,
            ),
            onPressed: () {
              if (animationDone) {
                Provider.of<UserStateService>(context, listen: false)
                    .setLevelAnimatedFalse();
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
