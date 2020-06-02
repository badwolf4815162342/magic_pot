import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

import '../logger.util.dart';

class AnimalSelectorButton extends StatelessWidget {
  AnimalSelectorButton({@required this.animal, @required this.size});
  final Animal animal;
  final double size;

  @override
  Widget build(BuildContext context) {
    var currentAnimal =
        Provider.of<UserModel>(context, listen: false).currentAnimal;
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
        if (currentAnimal == null) {
          Navigator.pushNamed(context, "menuScreenRoute");
        } else {
          Navigator.pop(context);
        }
        Provider.of<UserModel>(context, listen: false).changeAnimal(animal);
        final log = getLogger();
        log.d('AnimalSelectorButton: Tapped');
      },
      shape: const StadiumBorder(),
    );
  }
}
