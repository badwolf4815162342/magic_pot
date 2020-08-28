import 'package:flutter/material.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:provider/provider.dart';

class DarkableImage extends StatelessWidget {
  DarkableImage({@required this.url, this.height, this.width, this.fit});
  final String url;
  final double height;
  final double width;
  final BoxFit fit;
  AudioPlayerService audioPlayerService;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);
    var witchTalking = audioPlayerService.witchTalking;

    return ColorFiltered(
        colorFilter: witchTalking
            ? ColorFilter.matrix(
                <double>[
                  0.45,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0.4,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0.4,
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
        child: Image.asset(url,
            height: height,
            width: width,
            // color: lockScreen ? Constant.darkenColor : null,
            // colorBlendMode: lockScreen ? BlendMode.saturation : null,
            fit: BoxFit.fill));
  }
}