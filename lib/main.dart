import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:magic_pot/util/logger.util.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/provider/audio_player.service.dart';
import 'package:magic_pot/provider/user_state.service.dart';
import 'package:magic_pot/screens/animal_selection/animal_selection_screen.dart';
import 'package:magic_pot/screens/explanation_screen.dart';
import 'package:magic_pot/screens/intro_screen.dart';
import 'package:magic_pot/screens/level_finished_screen.dart';
import 'package:magic_pot/screens/level/level_screen.dart';
import 'package:magic_pot/screens/menu/menu_screen.dart';
import 'package:magic_pot/screens/animal_selection/select_first_animal_screen.dart';
import 'package:magic_pot/util/size.util.dart';
import 'package:provider/provider.dart';
import 'util/logger.util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final AudioPlayerService audioPlayerService = AudioPlayerService();
    audioPlayerService.init();
    final UserStateService userStateService = UserStateService();
    userStateService.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      // CartModel is implemented as a ChangeNotifier, which calls for the use
      // of ChangeNotifierProvider. Moreover, CartModel depends
      // on CatalogModel, so a ProxyProvider is needed.
      ChangeNotifierProvider(create: (_) => AudioPlayerService()),
      ChangeNotifierProvider(create: (_) => UserStateService())
    ], child: IntroPage());
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({
    Key key,
  }) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with WidgetsBindingObserver {
  AudioPlayerService audioPlayerService;

  @override
  Widget build(BuildContext context) {
    audioPlayerService = Provider.of<AudioPlayerService>(context);
    final log = getLogger();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroScreen(),
      onGenerateRoute: (RouteSettings routeSettings) {
        log.d("Change Screen: To " + routeSettings.name);
        // Screen comes from above

        return new PageRouteBuilder<dynamic>(
            settings: routeSettings,
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              switch (routeSettings.name) {
                case MenuScreen.routeTag:
                  return MenuScreen();
                case AnimalSelectionScreen.routeTag:
                  return AnimalSelectionScreen();
                case SelectFirstAnimalScreen.routeTag:
                  return SelectFirstAnimalScreen();
                case ExplanationScreen.routeTag:
                  return ExplanationScreen();
                case LevelScreen.routeTag:
                  return LevelScreen();
                case LevelFinishedScreen.routeTag:
                  return LevelFinishedScreen();
                default:
                  return null;
              }
            },
            transitionDuration: const Duration(milliseconds: 2000),
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              return effectMap[PageTransitionType.rippleMiddle](Curves.linear, animation, secondaryAnimation, child);
            });
      },
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    final log = getLogger();

    switch (state) {
      case AppLifecycleState.inactive:
        audioPlayerService.stopAllSound();
        log.i('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        log.i('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        audioPlayerService.stopAllSound();
        log.i('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        audioPlayerService.stopAllSound();
        log.i('appLifeCycleState detached');
        break;
      default:
        break;
    }
  }
}

class StartPageDetector extends StatelessWidget {
  static const String routeTag = 'menuPageRoute';
  @override
  Widget build(BuildContext context) {
    // get initial device sizes
    SizeUtil.width = MediaQuery.of(context).size.width;
    SizeUtil.height = MediaQuery.of(context).size.height;

    final log = getLogger();
    Animal animal = Provider.of<UserStateService>(context).currentAnimal;
    log.i('MenuPage:' + 'Animal=' + animal.toString());
    if (animal == null) {
      return SelectFirstAnimalScreen();
    } else {
      return MenuScreen();
    }
  }
}
