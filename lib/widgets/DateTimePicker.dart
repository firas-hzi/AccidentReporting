import 'package:accident_archive/Model/AccidentData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'TextFormField.dart';
import 'TextStyle.dart';

class DateTimePickerClass extends StatefulWidget {
  final Accident accident;
  final String type;
  DateTimePickerClass(this.accident, this.type);
  @override
  _DateTimePickerClassState createState() => _DateTimePickerClassState();
}

class _DateTimePickerClassState extends State<DateTimePickerClass> {
  final format = DateFormat("dd-MMM-yy HH:mm a");
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      initialValue:
          widget.type == 'C' ? widget.accident.claimDay : widget.accident.when,
      style: textStyle,
      textAlign: TextAlign.center,
      decoration: textInputDecoration.copyWith(
          labelText: widget.type == 'C'
              ? 'Claim tag field (${format.pattern})'
              : 'Wann field (${format.pattern})'),
      format: format,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          setState(() {
            widget.type == 'C'
                ? widget.accident.claimDay = DateTimeField.combine(date, time)
                : widget.accident.when = DateTimeField.combine(date, time);
          });

          return DateTimeField.combine(date, time);
        } else {
          setState(() {
            widget.type == 'C'
                ? widget.accident.claimDay = currentValue
                : widget.accident.when = currentValue;
          });
          return currentValue;
        }
      },
    );
  }
}
