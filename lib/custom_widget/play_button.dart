import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:magic_pot/custom_widget/blink_widget.dart';
import 'package:magic_pot/custom_widget/empty_placeholder.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
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
            child: new Image.asset(
              'assets/pics/play_blue.png',
              width: double.parse(
                  GlobalConfiguration().getString("play_button_size")),
              height: double.parse(
                  GlobalConfiguration().getString("play_button_size")),
            ),
            onPressed: () {
              if (animationDone) {
                Provider.of<ControllingProvider>(context, listen: false)
                    .setLevelAnimatedFalse();
              }
              Navigator.pushNamed(context, pushedName);
            },
          ),
          RawMaterialButton(
            child: new Image.asset(
              'assets/pics/play_blue_light.png',
              width: double.parse(
                  GlobalConfiguration().getString("play_button_size")),
              height: double.parse(
                  GlobalConfiguration().getString("play_button_size")),
            ),
            onPressed: () {
              if (animationDone) {
                Provider.of<ControllingProvider>(context, listen: false)
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
