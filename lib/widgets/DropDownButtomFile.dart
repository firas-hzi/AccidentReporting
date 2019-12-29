import 'package:accident_archive/Model/AccidentData.dart';
import 'package:flutter/material.dart';

class DropDownButtonTire extends StatefulWidget {
  final Tire tire;
  DropDownButtonTire(this.tire);
  @override
  _DropDownButtonTireState createState() => _DropDownButtonTireState();
}

class _DropDownButtonTireState extends State<DropDownButtonTire> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.tire.profile,
      icon: Icon(
        Icons.arrow_downward,
        color: Colors.white,
      ),
      iconSize: 18,
      elevation: 16,
      style: TextStyle(color: Colors.lightBlue, fontSize: 24),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String newValue) {
        setState(() {
          widget.tire.profile = newValue;
        });
      },
      items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
