import 'package:flutter/material.dart';

class SourceToggleButtons extends StatefulWidget {
  final ValueChanged<int> onChanged;

  const SourceToggleButtons({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SourceToggleButtons> createState() => _SourceToggleButtonsState();
}

class _SourceToggleButtonsState extends State<SourceToggleButtons> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          color: Colors.white70,
          child: ToggleButtons(
            isSelected: isSelected,
            selectedColor: Colors.white,
            color: Colors.black,
            fillColor: Colors.green,
            renderBorder: false,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Download', style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Storage', style: TextStyle(fontSize: 18)),
              ),
            ],
            onPressed: (newIndex) {
              setState(() {
                for (int index = 0; index < isSelected.length; index++) {
                  if (index == newIndex) {
                    isSelected[index] = true;
                  } else {
                    isSelected[index] = false;
                  }
                }

                widget.onChanged(newIndex);
              });
            },
          ),
        ),
      );
}
