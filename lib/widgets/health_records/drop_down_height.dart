import 'package:flutter/material.dart';

class DropDownHeight extends StatefulWidget {
  const DropDownHeight({Key? key}) : super(key: key);

  @override
  State<DropDownHeight> createState() => _DropDownHeightState();
}

class _DropDownHeightState extends State<DropDownHeight> {
  String dropdownValue = "Feet";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 4, bottom: 4),
            child: DropdownButton(
              value: dropdownValue,
              isExpanded: true,
              items: <String>['Feet', 'Cm', 'Mts'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? newValue) {
                // do something here
                if (mounted) {
                  setState(() {
                    dropdownValue = newValue ?? dropdownValue;
                  });
                }
              },
              underline: DropdownButtonHideUnderline(child: Container()),
            ),
          ),
        ),
      ),
    );
  }
}
