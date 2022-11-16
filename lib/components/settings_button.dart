import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final String title;
  final Function() function;

  const SettingsButton(this.title, this.function, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      elevation: 2.0,
      primary: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(width: 1.0, color: Colors.teal)),
    );
    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: function,
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(color: Colors.teal),
          )),
    );
  }
}
