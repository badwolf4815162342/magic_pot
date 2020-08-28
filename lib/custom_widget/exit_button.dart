import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/custom_widget/darkable_image.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/menu_screen.dart';
import 'package:provider/provider.dart';

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
      child: new Image.asset(
        'assets/pics/x_pink.png',
        width: 70,
        height: 70,
      ),
      onPressed: () {
        audioPlayerService.stopAllSound();
        _showAlertDialog(audioPlayerService, userStateService);
        audioPlayerService.quitButtonText(widget.closeApp);
      },
    );
  }

  void _showAlertDialog(AudioPlayerService audioPlayerService,
      UserStateService userStateService) {
    var lockScreen = audioPlayerService.lockScreen;
    showDialog(
      //barrierDismissible: false,
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
                        userStateService.saveCurrentAnimal();
                        Navigator.of(context).pop();
                        audioPlayerService.stopAllSound();
                        SystemNavigator.pop();
                      } else {
                        Navigator.of(context).pop();
                        // reset all
                        Navigator.pushNamed(context, MenuScreen.routeTag);
                        audioPlayerService.resetAudioPlayerToMenu();
                        Provider.of<UserStateService>(context)
                            .resetPlayPositon();
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
