import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  late String text;
  late Function onPressed;

  Button(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Colors.red,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        onPressed: () => onPressed()
    );
  }
}
