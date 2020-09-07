import 'package:flutter/material.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:provider/provider.dart';

// This class makes visible that buttons are uncklickable when the witch is talking
class DarkableImage extends StatelessWidget {
  DarkableImage({@required this.url, this.height, this.width, this.fit});
  final String url;
  final double height;
  final double width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    AudioPlayerService audioPlayerService = Provider.of<AudioPlayerService>(context);
    var witchTalking = audioPlayerService.witchTalking;
    var stayBright = audioPlayerService.stayBright;

    return ColorFiltered(
        colorFilter: witchTalking && !stayBright
            ? ColorFilter.matrix(
                <double>[
                  0.65,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0.6,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0.6,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ],
              )
            : ColorFilter.mode(
                Colors.transparent,
                BlendMode.multiply,
              ),
        child: Image.asset(url, height: height, width: width, fit: BoxFit.fill));
  }
}
