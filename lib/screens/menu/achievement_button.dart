import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/util/logger.util.dart';
import 'package:provider/provider.dart';

// One level image in the cupboard on the menu screen to play this exact level again
class AchievementButton extends StatelessWidget {
  final log = getLogger();

  AchievementButton(
      {@required this.level, @required this.animalwidth, @required this.animalheight, @required this.animate});
  final Level level;
  final double animalwidth;
  final double animalheight;

// animate that this was a new achievement
  final bool animate;

  void _showAlertDialog(BuildContext context) {
    AudioPlayerService audioPlayerService = Provider.of<AudioPlayerService>(context);
    var lockScreen = audioPlayerService.lockScreen;
    // TODO(viviane): Solve locked bug ???
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
                    // TODO(viviane): Should selecting the achievement image to  go to the level stop the sound
                    audioPlayerService.stopAllSound();
                    Provider.of<UserStateService>(context, listen: false).setLevel(level);
                    Navigator.pushNamed(context, ExplanationScreen.routeTag);
                    Provider.of<UserStateService>(context, listen: false).setLevelAnimatedFalse();
                  },
                ),
                RawMaterialButton(
                  child: DarkableImage(
                    url: 'assets/pics/x_pink.png',
                    width: 100,
                    height: 100,
                  ),
                  onPressed: () {
                    // TODO(viviane): Should selecting x to not got to the level stop the sound
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
    AudioPlayerService audioPlayerService = Provider.of<AudioPlayerService>(context);
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
                width: animalwidth,
                height: animalheight,
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
