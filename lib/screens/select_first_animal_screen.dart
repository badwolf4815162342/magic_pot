import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/animal_buttons.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class SelectFirstAnimalScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectFirstAnimalScreenState();
  }
}

class _SelectFirstAnimalScreenState extends State<SelectFirstAnimalScreen> {

 bool _checkConfiguration() => true;

  void initState() {
    super.initState();
    if (_checkConfiguration()) {
      Future.delayed(Duration.zero,() { // SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserModel>(context, listen: false).makeSound('audio/intro.wav');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var lockScreen = Provider.of<UserModel>(context).lockScreen;
    var witchIcon = Provider.of<UserModel>(context).witchIcon;

    return Consumer<UserModel>(
      builder: (context, cart, child) {
        return Scaffold(
            body: IgnorePointer(
                ignoring:  lockScreen,
                child: Stack(children: <Widget>[
                  Center(
                    child: new Image.asset(
                      'assets/pics/animal_selection.png',
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Row ( mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column ( 
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonsWithName(animalsize: 150)
                    ]
                  ),
                  FlatButton(
                            child: new Image.asset(
                            witchIcon,
                            height: 300,
                            width: 300,
                          ),
                            onPressed: () {
                              Provider.of<UserModel>(context).playWitchText();
                            },
                      )
                    ])
                  
                ]
            )
          )
        );
      },
    );
  }
}
