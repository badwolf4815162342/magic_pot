import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:magic_pot/models/animal.dart';
import 'package:magic_pot/models/level.dart';
import 'package:magic_pot/models/user.dart';
import 'package:provider/provider.dart';

import '../logger.util.dart';

class ArchievementButton extends StatelessWidget {
  ArchievementButton({@required this.level, @required this.size});
  final Level level;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Image.asset(
              level.picAftereUrl,
              width: size,
              height: size,
            ),
          ],
        ),
      ),
      onPressed: () {
        final log = getLogger();
        log.d('ArchievementButton: Tapped');
        // Go to that expanation screen with level
        Provider.of<UserModel>(context, listen: false).setLevel(level);
        Navigator.pushNamed(context, "/explanation");
      },
      shape: const StadiumBorder(),
    );
  }
}
