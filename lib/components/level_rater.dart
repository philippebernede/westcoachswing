import 'package:flutter/material.dart';

class LevelRater extends StatelessWidget {
  final String text;
  final bool selection;
  final int index;
  final Function toggleSelection;
  const LevelRater(this.text, this.selection, this.index, this.toggleSelection,
      {Key? key})
      : super(key: key);

  final Icon selectedIcon = const Icon(
    Icons.star,
    color: Colors.teal,
  );
  final Icon unSelectedIcon = const Icon(
    Icons.star_border,
    color: Colors.teal,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(
          child: Text(text),
          fit: BoxFit.contain,
        ),
        IconButton(
            icon: selection ? selectedIcon : unSelectedIcon,
            onPressed: () {
              toggleSelection(!selection, index);
            })
      ],
    );
  }
}
