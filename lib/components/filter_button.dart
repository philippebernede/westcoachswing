import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final bool isActive;
  final String filterText;
  final Function updateValue;

  const FilterButton(this.filterText, this.isActive, this.updateValue,
      {Key? key})
      : super(key: key);

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  final Color inactiveColor = Colors.white;
  bool? isActives;
  Color setColor(bool? selected) {
    if (selected != null) {
      return selected
          ? Theme.of(context).colorScheme.secondary.withOpacity(0.7)
          : inactiveColor;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    isActives ??= widget.isActive;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
              side: const BorderSide(color: Colors.teal)),
          child: FittedBox(
              child: Text(
            widget.filterText,
            style: TextStyle(color: isActives! ? Colors.white : Colors.teal),
          )),
          elevation: 10.0,
          color: setColor(isActives!),
          onPressed: () {
            setState(() {
              if (isActives == true) {
                isActives = false;
                widget.updateValue(isActives);
              } else {
                isActives = true;
                widget.updateValue(isActives);
              }

//              buttonColor(widget.isActive);
            });
          },
        ),
      ),
    );
  }
}
