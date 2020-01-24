import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class AnimalSelectorButton extends StatelessWidget {
  AnimalSelectorButton({@required this.animal});
  final Animal animal;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${animal.picture}",
                style: TextStyle(
                  fontSize: 130,
                )),
            /*Text(
              "${animal.name}",
              maxLines: 1,
              style: TextStyle(color: Colors.white),
            ),*/
          ],
        ),
      ),
      onPressed: () {
        if (animal == null) {
          Navigator.pushNamed(context, "menuScreenRoute");
        } else {
          Navigator.pop(context);
        }
        Provider.of<UserModel>(context, listen: false).changeAnimal(animal);

        print("Tapped Me");
      },
      shape: const StadiumBorder(),
    );
  }
}
