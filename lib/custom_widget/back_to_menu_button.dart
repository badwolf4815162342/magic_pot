import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class BackToMenuButton extends StatefulWidget {
  final double animalsize;

  const BackToMenuButton({Key key, this.animalsize}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BackToMenuButtonState();
  }
}

class _BackToMenuButtonState extends State<BackToMenuButton> {
  void _showAlertDialog() {
    showDialog(
      //barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Image.asset(
            'assets/pics/impressum_blue.png',
            width: 200,
            height: 200,
          ),
          content: Text(
            'Back to Menu and loose all progress',
            style: TextStyle(color: Colors.purple),
          ),
          backgroundColor: Color(0xffb74093),
          actions: <Widget>[
            RawMaterialButton(
              child: new Image.asset(
                'assets/pics/ok_blue.png',
                width: 100,
                height: 100,
              ),
              onPressed: () {
                //_counterZero();
                Navigator.of(context).pop();
                // reset all
                Provider.of<UserModel>(context).resetToMenu();
                Navigator.pushNamed(context, '/menu');
              },
            ),
            RawMaterialButton(
              child: new Image.asset(
                'assets/pics/x_pink.png',
                width: 100,
                height: 100,
              ),
              onPressed: () {
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
    return RawMaterialButton(
      child: new Image.asset(
        'assets/pics/x_pink.png',
        width: 100,
        height: 100,
      ),
      onPressed: () {
        Provider.of<UserModel>(context).stopAllSound();

        _showAlertDialog();
      },
    );
  }
}
