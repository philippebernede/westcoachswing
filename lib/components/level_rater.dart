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
    color: Colors.yellow,
  );
  final Icon unSelectedIcon = const Icon(
    Icons.star_border,
    color: Colors.yellow,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(text),
        IconButton(
            icon: selection ? selectedIcon : unSelectedIcon,
            onPressed: () {
              toggleSelection(!selection, index);
            })
      ],
    );
  }
}
