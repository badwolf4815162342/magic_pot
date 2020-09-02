import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/menu/menu_screen.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:provider/provider.dart';

import '../../util/logger.util.dart';

class AnimalButton extends StatelessWidget {
  AnimalButton({@required this.animal, @required this.size});
  final Animal animal;
  final double size;
  var _firstPress = true;
  AudioPlayerService audioPlayerService;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context, listen: false);
    var currentAnimal = Provider.of<UserStateService>(context, listen: false).currentAnimal;
    return RawMaterialButton(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DarkableImage(
              url: animal.picture,
              width: size,
            ),
          ],
        ),
      ),
      onPressed: () {
        if (_firstPress) {
          _firstPress = false;
          audioPlayerService.makeAnimalSound(animal.soundfile);
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (currentAnimal == null) {
              Navigator.pushNamed(context, MenuScreen.routeTag);
            } else {
              Navigator.pop(context);
            }
          });
          Provider.of<UserStateService>(context, listen: false).changeAnimal(animal);
          final log = getLogger();
          log.d('AnimalSelectorButton: Tapped');
        }
      },
      shape: const StadiumBorder(),
    );
  }
}
