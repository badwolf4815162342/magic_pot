import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/menu/menu_screen.dart';
import 'package:magic_pot/shared_widgets/darkable_image.dart';
import 'package:magic_pot/util/constant.util.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';

// Red exit button to go back to menu or when in menu close the app
class ImpressumButton extends StatefulWidget {
  const ImpressumButton({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImpressumButtonState();
  }
}

class _ImpressumButtonState extends State<ImpressumButton> {
  AudioPlayerService audioPlayerService;
  UserStateService userStateService;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);
    userStateService = Provider.of<UserStateService>(context);

    return RawMaterialButton(
      child: DarkableImage(
        url: 'assets/pics/impressum_blue.png',
        width: SizeUtil.getDoubleByDeviceHorizontal(Constant.xButtonSize),
        height: SizeUtil.getDoubleByDeviceHorizontal(Constant.xButtonSize),
      ),
      onPressed: () {
        // TODO(viviane): Should selecting x during the level stop all sound and be clickable even when the witch is talking?
        audioPlayerService.stopAllSound();
        _showAlertDialog(audioPlayerService, userStateService);
      },
    );
  }

  void _showAlertDialog(AudioPlayerService audioPlayerService, UserStateService userStateService) {
    var lockScreen = audioPlayerService.lockScreen;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          title: Text('Impressum'),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return Container(
                  color: Color(0xA48395),
                  height: height - 400,
                  width: width - 400,
                  child: Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: 'Learning4Kids ERC Starting Grant: 801980 (gefördert durch die EU)',
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Kontakt bei technischen Fragen - LMU IT HelpDesk L4K',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    'Ludwig-Maximilians-Universität München Fakultät für Psychologie und Pädagogik; Informationstechnologie',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'Telefon: +49-(0)89-2180-6927E-Mail: support.l4k@lmu.deWebsite: www.psy.lmu.de/ffp/forschung/ag-niklas/learning-4kids/index.html'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text:
                              'Kontakt ProjektleiterProf. Dr. Frank NiklasLudwig-Maximilians-Universität MünchenDepartment PsychologieLeopoldstr.13, 80802 MünchenTelefon: +49-(0)89-2180-5166E-Mail: niklas@psy.lmu.de',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' world!'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text:
                              'Grafiken, Inhalte und Umsetzung der AppJan Essig, Dipl. Designer (FH)Storchensteinstrasse 84 DD-68259 MannheimE-Mail:info@janessig.comWebsite: www.janessig.com',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' world!'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text:
                              'NutzungsbedingungenGrafiken, Illustrationen, Spiele und Dateien dieser App unterliegen dem Urheberrecht und anderen Gesetzen zum Schutz des geistigen Eigentums. Ihre Weitergabe, Veränderung, gewerbliche Nutzung oder Verwendung in anderen Medien ist nicht gestattet. Alle Rechte vorbehalten.HaftungshinweisTrotz sorgfältiger inhaltlicher Kontrolle übernehmen wir keine Haftung für die Inhalte externer Links. Für den Inhalt der verlinkten Seiten sind ausschliesslich deren Betreiber verantwortlich. Angabe gemäss § 6 und § 7 Anbieterkennzeichnung des TDG.',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' world!'),
                          ],
                        ),
                      )
                    ],
                  ));
            },
          ),
          actions: <Widget>[
            RawMaterialButton(
              child: DarkableImage(
                url: 'assets/pics/x_pink.png',
                width: 100,
                height: 100,
              ),
              onPressed: () {
                if (!lockScreen) {
                  Navigator.of(context).pop();
                  // TODO(viviane): Should selecting the witch to go back to menu stop the sound (or should it be only cklickabale when explanation is finished)
                  audioPlayerService.resetAudioPlayerToMenu();
                  Provider.of<UserStateService>(context).resetPlayPositon();
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }
}
