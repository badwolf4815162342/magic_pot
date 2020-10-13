import 'package:flutter/material.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/level_state.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/level/ingredient_draggable_list.dart';
import 'package:magic_pot/screens/level/magic_pot.dart';
import 'package:magic_pot/shared_widgets/background_layout.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

import '../../util/logger.util.dart';

// Screen for one level (one potions that needs x correct ingedients in a row) with the MagicPot as DragTarget
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

  void initState() {
    super.initState();
    madeInitSound = false;
  }

// Explain what the next accepted object will be
  _tellAccetedObject(bool init) {
    num milliseconds = 3000;
    if (init) {
      milliseconds = 1000;
    }
    Future.delayed(Duration(milliseconds: milliseconds), () {
      audioPlayerService.updateWitchText(
          'audio/witch_${_levelStateService.acceptedObject.name}.wav');
      audioPlayerService.explainAcceptedObject(
        'audio/witch_${_levelStateService.acceptedObject.name}.wav',
      );
    });
  }

// check if enaugh correct ingredients in a row where inserted into the potion
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
      // if not show next ingredient selection
      _levelStateService.resetLevelData();
      _tellAccetedObject(false);
    }
  }

// check if to many incorrect objects were put in the potion in a row and motivate the player
  _checkForResetIngredient() {
    if (_levelStateService.wrongcounter == currentLevel.getMaxFaults()) {
      audioPlayerService.resetIngredient();
      _levelStateService.wrongcounter = 0;
      _levelStateService.resetLevelData();
      _tellAccetedObject(false);
    } else {
      audioPlayerService.motivation();
    }
  }

  _onAccept(data) {
    log.d('LevelScreen: Data: ' +
        data +
        ' Accepted obj ' +
        _levelStateService.acceptedObject.toString());
    // CORRECT
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
      // INCORRECT
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

    if (madeInitSound == false) {
      _levelStateService = LevelStateService(
          currentLevel, SizeUtil.getDoubleByDeviceHorizontal(100));
      madeInitSound = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        _levelStateService.resetLevelData();
        _tellAccetedObject(true);
      });
    }

    return Scaffold(
        key: scaffoldKey,
        body: BackgroundLayout(
            scene: LayoutBuilder(
              builder: (context, constraints) {
                return ChangeNotifierProvider.value(
                    value: _levelStateService,
                    child: Consumer<LevelStateService>(
                        builder: (context, levelStateService, child) => Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Row(children: [
                                  SizedBox(
                                    width: SizeUtil.getDoubleByDeviceHorizontal(
                                        80),
                                  ),
                                  Column(children: [
                                    SizedBox(
                                      height:
                                          SizeUtil.getDoubleByDeviceVertical(
                                              450),
                                    ),
                                    MagicPot(
                                      size: SizeUtil.getDoubleByDeviceVertical(
                                          300),
                                      levelStateService: levelStateService,
                                      callback: (data) {
                                        _onAccept(data);
                                      },
                                    ),
                                  ]),
                                ]),
                                Row(children: [
                                  SizedBox(
                                      height:
                                          SizeUtil.getDoubleByDeviceVertical(
                                              10),
                                      width:
                                          SizeUtil.getDoubleByDeviceHorizontal(
                                              580)),
                                  IngredientDraggableList(
                                      height:
                                          SizeUtil.getDoubleByDeviceVertical(
                                              570),
                                      currentDraggables: levelStateService
                                          .currentIngredientDraggables)
                                ])
                              ],
                            )));
              },
            ),
            picUrl: 'assets/pics/level_background.png'));
  }

  @override
  void dispose() {
    super.dispose();
    _levelStateService.dispose();
  }
}
