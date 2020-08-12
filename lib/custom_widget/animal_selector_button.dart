import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/provider/controlling_provider.dart';
import 'package:magic_pot/screens/menu_screen.dart';
import 'package:provider/provider.dart';

import '../logger.util.dart';

class AnimalSelectorButton extends StatelessWidget {
  AnimalSelectorButton({@required this.animal, @required this.size});
  final Animal animal;
  final double size;
  var _firstPress = true;

  @override
  Widget build(BuildContext context) {
    var currentAnimal =
        Provider.of<ControllingProvider>(context, listen: false).currentAnimal;
    return RawMaterialButton(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Image.asset(
              animal.picture,
              width: size,
              height: size,
            ),
          ],
        ),
      ),
      onPressed: () {
        if (_firstPress) {
          _firstPress = false;
          Provider.of<ControllingProvider>(context, listen: false)
              .makeAnimalSound(animal.soundfile);
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (currentAnimal == null) {
              Navigator.pushNamed(context, MenuScreen.routeTag);
            } else {
              Navigator.pop(context);
            }
          });
          Provider.of<ControllingProvider>(context, listen: false)
              .changeAnimal(animal);
          final log = getLogger();
          log.d('AnimalSelectorButton: Tapped');
        }
      },
      shape: const StadiumBorder(),
    );
  }
}
