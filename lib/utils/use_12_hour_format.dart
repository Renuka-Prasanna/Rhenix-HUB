import 'package:flutter/material.dart';

String use12HourFormat(TimeOfDay pickedTime, MaterialLocalizations localizations) {
  //final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  String pickTimeIn24hrFormat = localizations.formatTimeOfDay(
    pickedTime,
    alwaysUse24HourFormat: false,
  );
  return pickTimeIn24hrFormat;
}
