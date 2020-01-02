import 'package:flutter/material.dart';
import 'package:magic_pot/custom_widget/background_layout.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

class SelectFirstAnimalScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectFirstAnimalScreenState();
  }
}

class _SelectFirstAnimalScreenState extends State<SelectFirstAnimalScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, cart, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Routing & Navigation"),
            ),
            body: BackgroundLayout(
              scene: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Wanna select first animal?',
                    ),
                    RaisedButton(
                      child: Text("Select cat"),
                      onPressed: () {
                        Animal animal =
                            Provider.of<UserModel>(context, listen: false)
                                .animals
                                .elementAt(0);
                        Provider.of<UserModel>(context, listen: false)
                            .changeAnimal(animal);
                      },
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
