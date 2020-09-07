import 'package:flutter/material.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class Witch extends StatelessWidget {
  const Witch({
    Key key,
    @required this.talking,
    @required this.rotate,
    @required this.size,
    this.standartWitchText = false,
  }) : super(key: key);

  final double size;
  final bool talking;
  final bool rotate;
  final bool standartWitchText;

  @override
  Widget build(BuildContext context) {
    AudioPlayerService audioPlayerService = Provider.of<AudioPlayerService>(context);

    return FlatButton(
      child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(rotate ? math.pi : 0),
          child: new Image.asset(
            talking ? Constant.talkingWitchIconPath : Constant.standartWitchIconPath,
            height: SizeUtil.getDoubleByDeviceVertical(size),
            width: SizeUtil.getDoubleByDeviceHorizontal(size),
          )),
      onPressed: () {
        if (!talking) {
          if (standartWitchText) {
            audioPlayerService.tellStandartWitchText();
          } else {
            audioPlayerService.playWitchText();
          }
        }
      },
    );
  }
}
