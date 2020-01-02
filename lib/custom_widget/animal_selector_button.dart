import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audio_cache.dart';

class AnimalSelectorButton extends StatelessWidget {
  AnimalSelectorButton({@required this.animal});
  final Animal animal;

  static AudioCache player = AudioCache();

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.green,
      splashColor: Colors.greenAccent,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${animal.picture}",
                style: TextStyle(
                  fontSize: 150,
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
        Provider.of<UserModel>(context, listen: false).changeAnimal(animal);
        player.play(animal.soundfile);
        Navigator.pop(context);
        print("Tapped Me");
      },
      shape: const StadiumBorder(),
    );
  }
}
