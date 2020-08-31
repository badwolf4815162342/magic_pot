import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/util/logger.util.dart';
import 'package:provider/provider.dart';

class AchievementButton extends StatelessWidget {
  final log = getLogger();

  AchievementButton(
      {@required this.level, @required this.size, @required this.animate});
  final Level level;
  final double size;
  final bool animate;
  AudioPlayerService audioPlayerService;
  UserStateService userStateService;

  void _showAlertDialog(BuildContext context) {
    var lockScreen = audioPlayerService.lockScreen;
    // TODO(viviane): Solve locked bug
    log.e('Screenlocked? $lockScreen');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return IgnorePointer(
            ignoring: false,
            child: AlertDialog(
              backgroundColor: Color(0x472d4a),
              actions: <Widget>[
                RawMaterialButton(
                  constraints: BoxConstraints(minHeight: 200, minWidth: 200),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.only(top: 100),
                  child: DarkableImage(
                    url: level.picAftereUrl,
                    width: 200,
                    height: 200,
                  ),
                  onPressed: () {
                    // Go to that expanation screen with level
                    audioPlayerService.stopAllSound();
                    Provider.of<UserStateService>(context, listen: false)
                        .setLevel(level);
                    Navigator.pushNamed(context, ExplanationScreen.routeTag);
                    Provider.of<UserStateService>(context, listen: false)
                        .setLevelAnimatedFalse();
                  },
                ),
                RawMaterialButton(
                  child: DarkableImage(
                    url: 'assets/pics/x_pink.png',
                    width: 100,
                    height: 100,
                  ),
                  onPressed: () {
                    audioPlayerService.stopAllSound();

                    Navigator.of(context).pop();
                  },
                ),
              ],
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    userStateService = Provider.of<UserStateService>(context);
    audioPlayerService = Provider.of<AudioPlayerService>(context);

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
              DarkableImage(
                url: level.picAftereUrl,
                width: size,
                height: size - 6,
              ),
            ],
          ),
          onPressed: () {
            log.d('ArchievementButton: Tapped');
            audioPlayerService.archievementButtonText(level.finalLevel);
            if (!level.finalLevel) {
              _showAlertDialog(context);
            }
          },
        ));
  }
}
