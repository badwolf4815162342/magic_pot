import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/menu/menu_screen.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

// Red exit button to go back to menu or when in menu close the app
class ImpressumButton extends StatefulWidget {
  const ImpressumButton({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImpressumButtonState();
  }
}

class _ImpressumButtonState extends State<ImpressumButton> {
  AudioPlayerService audioPlayerService;
  UserStateService userStateService;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);
    userStateService = Provider.of<UserStateService>(context);

    return RawMaterialButton(
      child: DarkableImage(
        url: 'assets/pics/impressum_blue.png',
        width: SizeUtil.getDoubleByDeviceHorizontal(Constant.xButtonSize),
        height: SizeUtil.getDoubleByDeviceHorizontal(Constant.xButtonSize),
      ),
      onPressed: () {
        audioPlayerService.stopAllSound();
        _showAlertDialog(audioPlayerService, userStateService);
      },
    );
  }

  void _showAlertDialog(AudioPlayerService audioPlayerService, UserStateService userStateService) {
    var lockScreen = audioPlayerService.lockScreen;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          title: Text('Impressum - Learning4Kids'),
          backgroundColor: Colors.deepPurple[100],
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return Image.asset('assets/pics/impressum_pic.png', height: height, width: width, fit: BoxFit.fitHeight);
            },
          ),
          actions: <Widget>[
            RawMaterialButton(
              child: DarkableImage(
                url: 'assets/pics/x_pink.png',
                width: 100,
                height: 100,
              ),
              onPressed: () {
                if (!lockScreen) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }
}
