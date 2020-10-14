import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

// Red exit button to go back to menu or when in menu close the app
class ResetButton extends StatefulWidget {
  const ResetButton({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ResetButtonState();
  }
}

class _ResetButtonState extends State<ResetButton> {
  AudioPlayerService audioPlayerService;
  UserStateService userStateService;
  final GlobalKey<FormState> _keyDialogForm = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context, listen: false);
    userStateService = Provider.of<UserStateService>(context, listen: false);

    return RawMaterialButton(
      child: DarkableImage(
        url: 'assets/pics/reverse_blue.png',
        width: SizeUtil.getDoubleByDeviceHorizontal(Constant.xButtonSize),
        height: SizeUtil.getDoubleByDeviceHorizontal(Constant.xButtonSize),
      ),
      onPressed: () {
        // TODO(viviane): Should selecting x during the level stop all sound and be clickable even when the witch is talking?
        //_showAlertDialog(userStateService);
        _displayDialog(userStateService, audioPlayerService);
      },
    );
  }

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(UserStateService userStateService, AudioPlayerService audioPlayerService) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple[100],
            title: Text('Alle bisher erreichten Tränke zurücksetzen?'),
            content: Column(children: <Widget>[
              Text(
                  'Hier sollte ein Erwachsener folgende Frage beantworten, num alles auf den Anfangszustand zurück zu setzen: 342 geteilt durch 18 ist gleich was?'),
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Ergebnis ..."),
              )
            ]),
            actions: <Widget>[
              RawMaterialButton(
                child: DarkableImage(
                  url: 'assets/pics/x_pink.png',
                  width: 100,
                  height: 100,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RawMaterialButton(
                child: DarkableImage(
                  url: 'assets/pics/reverse_blue.png',
                  width: 100,
                  height: 100,
                ),
                onPressed: () {
                  if (_textFieldController.text == '19') {
                    // delete
                    userStateService.resetAll();
                    audioPlayerService.pring();
                    audioPlayerService.resetAudioPlayerToMenu();
                    userStateService.resetPlayPositon();
                  } else {
                    audioPlayerService.error();
                  }
                  Navigator.of(context).pop();
                  _textFieldController.text = '';
                },
              ),
            ],
          );
        });
  }
}
