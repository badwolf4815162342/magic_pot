import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
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
  bool _checkConfiguration() => true;

  void _showAlertDialog() {
    var lockScreen = Provider.of<ControllingProvider>(context).lockScreen;
    showDialog(
      //barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0x472d4a),
          buttonPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          actions: <Widget>[
            RawMaterialButton(
              child: new Image.asset(
                'assets/pics/x_pink.png',
                width: 100,
                height: 100,
              ),
              onPressed: () {
                if (!lockScreen) {
                  if (widget.closeApp) {
                    Provider.of<ControllingProvider>(context)
                        .saveCurrentAnimal();
                    Navigator.of(context).pop();
                    Provider.of<ControllingProvider>(context).stopAllSound();
                    SystemNavigator.pop();
                  } else {
                    //_counterZero();
                    Navigator.of(context).pop();
                    // reset all
                    Provider.of<ControllingProvider>(context).resetToMenu();
                    Navigator.pushNamed(context, MenuScreen.routeTag);
                  }
                }
              },
            ),
            RawMaterialButton(
              child: new Image.asset(
                'assets/pics/witch_pink_smile.png',
                width: 150,
                height: 150,
              ),
              onPressed: () {
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: new Image.asset(
        'assets/pics/x_pink.png',
        width: 70,
        height: 70,
      ),
      onPressed: () {
        //TODO: Make exit sound/explanation
        _showAlertDialog();
        Provider.of<ControllingProvider>(context, listen: false)
            .quitButtonText(widget.closeApp);
      },
    );
  }
}
