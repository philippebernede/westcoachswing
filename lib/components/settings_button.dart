import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final String title;
  final Function() function;

  const SettingsButton(this.title, this.function, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(width: 1.0, color: Colors.teal)),
      onPressed: function,
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(color: Colors.teal),
          )),
    );
  }
}
