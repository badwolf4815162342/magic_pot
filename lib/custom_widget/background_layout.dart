import 'package:flutter/material.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class BackgroundLayout extends StatelessWidget {
  BackgroundLayout({@required this.scene});
  final Widget scene;

  @override
  Widget build(BuildContext context) {
    var animal = Provider.of<UserModel>(context).currentAnimal;
    var pic;
    if (animal == null) {
      pic = "Nothing";
    } else {
      pic = animal.picture;
    }
    const double iconSize = 50;
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "🧙🏻‍♂️",
                style: TextStyle(
                  fontSize: 300,
                ),
              ),
              Text(
                "${pic}",
                style: TextStyle(
                  fontSize: 100,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Icon(Icons.switch_camera, semanticLabel: 'ADDED'),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, "animalSelectionScreenRoute");
                    },
                  ),
                ],
              ),
            ],
          ),
          flex: 1,
        ),
        Expanded(
          child: scene,
          flex: 2,
        ),
      ],
    );
  }
}
