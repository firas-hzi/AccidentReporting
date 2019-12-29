import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  enabledBorder: const OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red, width: 2.0),
  ),
  alignLabelWithHint: true,
  labelStyle: TextStyle(color: Colors.blueGrey,fontSize: 12),
);
