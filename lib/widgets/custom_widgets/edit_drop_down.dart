import 'package:flutter/material.dart';

class EditDropDown extends StatefulWidget {
  final double leftAndRightPadding;
  final double borderRadius;
  final Widget hint;
  final Function onPressed;
  final String? newvalue;
  String? editValue;
  final List<String> dropdownItems;

  EditDropDown({
    Key? key,
    required this.leftAndRightPadding,
    required this.borderRadius,
    required this.dropdownItems,
    required this.hint,
    required this.onPressed,
    this.newvalue,
    this.editValue,
  }) : super(key: key);

  @override
  State<EditDropDown> createState() => _EditDropDownState();
}

class _EditDropDownState extends State<EditDropDown> {
  late String _currentValue = widget.dropdownItems[0];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.leftAndRightPadding),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: EdgeInsets.only(left: widget.leftAndRightPadding, right: widget.leftAndRightPadding, top: 4, bottom: 4),
            child: DropdownButton(
              hint: widget.hint,
              value: widget.editValue,
              isExpanded: true,
              items: widget.dropdownItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newvalue) {
                setState(() {
                  widget.editValue = newvalue as String;
                });

                // do something here
                widget.onPressed(newvalue);
              },
              //underline: DropdownButtonHideUnderline(child: Container()),
            ),
          ),
        ),
      ),
    );
  }
}
