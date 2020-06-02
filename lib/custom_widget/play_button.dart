import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:magic_pot/custom_widget/blink_widget.dart';

class PlayButton extends StatelessWidget {
  PlayButton(
      {@required this.pushedName, this.opacity = 0.7, this.active = false});
  final String pushedName;
  final double opacity;
  final bool active;

  @override
  Widget build(BuildContext context) {
    if (active == true) {
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
              Navigator.pushNamed(context, pushedName);
            },
          ),
          Opacity(
              opacity: opacity,
              child: RawMaterialButton(
                child: new Image.asset(
                  'assets/pics/play_blue.png',
                  width: double.parse(
                      GlobalConfiguration().getString("play_button_size")),
                  height: double.parse(
                      GlobalConfiguration().getString("play_button_size")),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, pushedName);
                },
              ))
        ],
      );
    } else {
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
              Navigator.pushNamed(context, pushedName);
            },
          ),
        ],
      );
    }
  }
}
