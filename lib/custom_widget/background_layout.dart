import 'package:flutter/material.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class BackgroundLayout extends StatelessWidget {
  BackgroundLayout({@required this.scene, @required this.picUrl});
  final Widget scene;
  final String picUrl;

  @override
  Widget build(BuildContext context) {
    var animal = Provider.of<UserModel>(context).currentAnimal;
    var lockScreen = Provider.of<UserModel>(context).lockScreen;
    var pic;
    if (animal == null) {
      pic = "Nothing";
    } else {
      pic = animal.picture;
    }
    const double iconSize = 50;
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Center(
          child: new Image.asset(
            picUrl,
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
          ),
        ),
        Center(
            child: Row(
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
                        child:
                            Icon(Icons.switch_camera, semanticLabel: 'ADDED'),
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
        )),
      ],
    );
  }
}
