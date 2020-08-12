import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:provider/provider.dart';

import '../logger.util.dart';

class ArchievementButton extends StatelessWidget {
  ArchievementButton(
      {@required this.level, @required this.size, @required this.animate});
  final Level level;
  final double size;
  final bool animate;

  void _showAlertDialog(BuildContext context) {
    var lockScreen = Provider.of<ControllingProvider>(context).lockScreen;

    showDialog(
      //barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0x472d4a),
          actions: <Widget>[
            RawMaterialButton(
              child: new Image.asset(
                level.picAftereUrl,
                width: 200,
                height: 200,
              ),
              onPressed: () {
                // Go to that expanation screen with level
                Provider.of<ControllingProvider>(context).stopAllSound();
                Provider.of<ControllingProvider>(context, listen: false)
                    .setLevel(level);
                Navigator.pushNamed(context, ExplanationScreen.routeTag);
                Provider.of<ControllingProvider>(context, listen: false)
                    .setLevelAnimatedFalse();
              },
            ),
            RawMaterialButton(
              child: new Image.asset(
                'assets/pics/x_pink.png',
                width: 100,
                height: 100,
              ),
              onPressed: () {
                Provider.of<ControllingProvider>(context).stopAllSound();

                Navigator.of(context).pop();
              },
            ),
          ],
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TranslationAnimatedWidget(
        enabled: animate, //update this boolean to forward/reverse the animation
        values: [
          Offset(0, 0), // disabled value value
          Offset(0, 100), //intermediate value
          Offset(0, 0) //enabled value
        ],
        child: RawMaterialButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Image.asset(
                level.picAftereUrl,
                width: size,
                height: size,
              ),
            ],
          ),
          onPressed: () {
            final log = getLogger();
            log.d('ArchievementButton: Tapped');
            Provider.of<ControllingProvider>(context, listen: false)
                .archievementButtonText(level.finalLevel);
            if (!level.finalLevel) {
              _showAlertDialog(context);
            }
          },
          shape: const StadiumBorder(),
        ));
  }
}
