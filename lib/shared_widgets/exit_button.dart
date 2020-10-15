import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/models/ingredient.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/menu/menu_screen.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

// Red exit button to go back to menu or when in menu close the app
class ExitButton extends StatefulWidget {
  final bool closeApp;

  const ExitButton({@required this.closeApp, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExitButtonState();
  }
}

class _ExitButtonState extends State<ExitButton> {
  AudioPlayerService audioPlayerService;
  UserStateService userStateService;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);
    userStateService = Provider.of<UserStateService>(context);

    return RawMaterialButton(
      child: DarkableImage(
        url: 'assets/pics/x_pink.png',
        width: SizeUtil.getDoubleByDeviceHorizontal(Constant.xButtonSize),
        height: SizeUtil.getDoubleByDeviceHorizontal(Constant.xButtonSize),
      ),
      onPressed: () {
        // TODO(viviane): Should selecting x during the level stop all sound and be clickable even when the witch is talking?
        audioPlayerService.stopAllSound();
        _showAlertDialog(audioPlayerService, userStateService);
        audioPlayerService.quitButtonText(widget.closeApp);
      },
    );
  }

  void _showAlertDialog(AudioPlayerService audioPlayerService, UserStateService userStateService) {
    var lockScreen = audioPlayerService.lockScreen;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return IgnorePointer(
            ignoring: lockScreen,
            child: AlertDialog(
              backgroundColor: Color(0x472d4a),
              buttonPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
              actions: <Widget>[
                RawMaterialButton(
                  child: DarkableImage(
                    url: 'assets/pics/x_pink.png',
                    width: 100,
                    height: 100,
                  ),
                  onPressed: () {
                    if (!lockScreen) {
                      if (widget.closeApp) {
                        // To be safe, save currently selected animal
                        userStateService.saveCurrentAnimal();
                        Navigator.of(context).pop();
                        // TODO(viviane): Should selecting x to close whole app stop the sound (or should it be only cklickabale when explanation is finished)
                        audioPlayerService.stopAllSound();
                        SystemNavigator.pop();
                      } else {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, MenuScreen.routeTag);
                        // TODO(viviane): Should selecting the witch to go back to menu stop the sound (or should it be only cklickabale when explanation is finished)
                        audioPlayerService.resetAudioPlayerToMenu();
                        Provider.of<UserStateService>(context).resetPlayPositon();
                      }
                    }
                  },
                ),
                RawMaterialButton(
                  child: DarkableImage(
                    url: 'assets/pics/witch_pink_smile.png',
                    width: 150,
                    height: 150,
                  ),
                  onPressed: () {
                    audioPlayerService.stopAllSound();
                    if (!lockScreen) {
                      if (!widget.closeApp) {
                        audioPlayerService.resetLastSound();
                      }
                      Navigator.of(context).pop();
                    }
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
}
