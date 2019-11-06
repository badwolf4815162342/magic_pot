import 'package:flutter/material.dart';

void main() => runApp(FirstNoRoutePage());

class FirstNoRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FlatButton(
        child: Text(
          'First Page',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SecondNoRoutePage(),
              ));
        },
      ),
    );
  }
}

class SecondNoRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Second Page',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
