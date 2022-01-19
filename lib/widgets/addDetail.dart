import 'package:flutter/material.dart';

class AddDetail extends StatelessWidget {
  late Function onPressed;

  AddDetail(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Colors.red,
        child: Icon(Icons.favorite),
        onPressed: () => onPressed()
    );
  }
}
