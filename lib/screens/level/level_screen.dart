import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/level_state.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/level/ingredient_draggable_list.dart';
import 'package:magic_pot/shared_widgets/background_layout.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:provider/provider.dart';

import '../../util/logger.util.dart';

class LevelScreen extends StatefulWidget {
  static const String routeTag = '/levelscreen';
  final log = getLogger();

  @override
  State<StatefulWidget> createState() {
    return _LevelScreenState();
  }
}

class _LevelScreenState extends State<LevelScreen> {
  final log = getLogger();
  AudioPlayerService audioPlayerService;
  LevelStateService _levelStateService;
  bool madeInitSound = false;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  Level currentLevel;

  _tellAccetedObject() {
    audioPlayerService.updateWitchText(
        'audio/witch_${_levelStateService.acceptedObject.name}.wav');
    // In main class
    Future.delayed(const Duration(milliseconds: 3000), () {
      audioPlayerService.explainAcceptedObject(
        'audio/witch_${_levelStateService.acceptedObject.name}.wav',
      );
    });
  }

  _checkForLevelFinished() {
    log.i('LevelScreen:' +
        'Levelcounter=  New counter ${_levelStateService.counter}');
    if (_levelStateService.counter >= currentLevel.numberOfMinObjects &&
        _levelStateService.rightcounter >=
            currentLevel.numberOfRightObjectsInARow) {
      Provider.of<UserStateService>(context, listen: false).levelUp();
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          Navigator.pushNamed(context, ExplanationScreen.routeTag);
        });
      });
    } else {
      _levelStateService.resetLevelData();
      _tellAccetedObject();
    }
  }

  _checkForResetIngredient() {
    if (_levelStateService.wrongcounter == currentLevel.getMaxFaults()) {
      audioPlayerService.resetIngredient();
    } else {
      audioPlayerService.motivation();
    }
  }

/*   _resetLevelData() async {
    final log = getLogger();
    log.i('LevelScreen:' + "reset level (_resetLevelData)");

    var random = new Random();
    acceptedObject = currentObjects[random.nextInt(currentObjects.length)];

    log.i('LevelScreen:' + "Acc ${acceptedObject.name}");

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        audioPlayerService.explainAcceptedObject(
          'audio/witch_${acceptedObject.name}.wav',
        );
      });
    });
    log.d('LevelScreen: on except over');
  } */

  _onAccept(data) {
    log.d('LevelScreen: Data: ' +
        data +
        ' Accepted obj ' +
        _levelStateService.acceptedObject.toString());
    if (data == _levelStateService.acceptedObject.name) {
      _levelStateService.setPotAnimationSuccess();
      if (_levelStateService.counter >= (currentLevel.numberOfMinObjects - 1) &&
          _levelStateService.rightcounter >=
              (currentLevel.numberOfRightObjectsInARow - 1)) {
        // if enaugh right objects found praise and don't say normal text (next level text will be told)
        audioPlayerService.praise(false);
      } else {
        audioPlayerService.praise(true);
      }
      _levelStateService.success();
      _checkForLevelFinished();
      _levelStateService.printLevelStateInfo();
    } else {
      _levelStateService.setPotAnimationFailure();
      _levelStateService.failure();
      _checkForResetIngredient();
    }
    _levelStateService.stopPotAnimation();
    log.d('LevelScreen: on except over');
  }

  @override
  Widget build(BuildContext context) {
    currentLevel =
        Provider.of<UserStateService>(context, listen: false).currentLevel;
    audioPlayerService = Provider.of<AudioPlayerService>(context);
    _levelStateService = LevelStateService(currentLevel);

    if (madeInitSound == false) {
      madeInitSound = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        // TODO(viviane): check if audioplayer works there
        _levelStateService.resetLevelData();
        _tellAccetedObject();
        //_resetLevelData();
      });
    }

    return Scaffold(
        key: scaffoldKey,
        body: BackgroundLayout(
            scene: LayoutBuilder(
              builder: (context, constraints) {
                //var ingredientDraggables = IngredientDraggables;
                return ChangeNotifierProvider.value(
                    value: _levelStateService,
                    child: Consumer<LevelStateService>(
                        builder: (context, levelStateService, child) => Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Row(children: [
                                  SizedBox(width: 80),
                                  Column(children: [
                                    SizedBox(height: 450),
                                    MagicPot(
                                      levelStateService: levelStateService,
                                      callback: (data) {
                                        _onAccept(data);
                                      },
                                    ),
                                  ]),
                                ]),
                                Row(children: [
                                  SizedBox(height: 10, width: 580),
                                  IngredientDraggableList(
                                      currentDraggables: levelStateService
                                          .currentIngredientDraggables)
                                ])
                              ],
                            )));
              },
            ),
            picUrl: 'assets/pics/level_background.png'));
  }
}

class MagicPot extends StatelessWidget {
  const MagicPot({
    Key key,
    @required this.levelStateService,
    @required this.callback,
  }) : super(key: key);

  final Function callback;
  final LevelStateService levelStateService;

  @override
  Widget build(BuildContext context) {
    return ShakeAnimatedWidget(
      enabled: levelStateService.shaking,
      duration: Duration(milliseconds: levelStateService.millismovement),
      shakeAngle: Rotation.deg(z: levelStateService.angleMovement),
      curve: Curves.linear,
      child: DragTarget(
        builder: (context, List<String> strings, unacceptedObjectList) {
          return Center(
            child: DarkableImage(
              url: levelStateService.potImage,
              width: 300,
              height: 300,
            ),
          );
        },
        onWillAccept: (data) {
          return true;
        },
        onAccept: (data) {
          callback(data);
        },
      ),
    );
  }
}
