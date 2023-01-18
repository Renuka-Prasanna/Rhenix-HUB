import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TextEditingController Age = TextEditingController();

class DatePicker extends StatefulWidget {
  final String label;
  final double circularRadius;
  final Function()? onTap;
  final TextEditingController? controller;

  const DatePicker({
    Key? key,
    required this.label,
    required this.circularRadius,
    this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DatePicker();
  }
}

class _DatePicker extends State<DatePicker> {
  TextEditingController dateinput = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    super.initState();
    dateinput.text = ""; //set the initial value of text field
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label,
            //label text of field
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(widget.circularRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
              borderRadius: BorderRadius.circular(widget.circularRadius),
            ),
          ),
          readOnly: true, //set it true, so that user will not able to edit text
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
