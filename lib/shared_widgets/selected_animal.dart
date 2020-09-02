import 'package:flutter/material.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

import 'empty_placeholder.dart';

class SelectedAnimal extends StatelessWidget {
  const SelectedAnimal({
    Key key,
    @required this.size,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    AudioPlayerService audioPlayerService =
        Provider.of<AudioPlayerService>(context);
    var animal = Provider.of<UserStateService>(context).currentAnimal;

    return Container(
      child: RawMaterialButton(
        child: (animal == null)
            ? EmptyPlaceholder()
            : DarkableImage(
                url: animal.picture,
                height: SizeUtil.getDoubleByDeviceVertical(size)),
        onPressed: () {
          audioPlayerService.makeAnimalSound(animal.soundfile);
        },
      ),
    );
  }
}
