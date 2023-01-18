import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final Function()? onTap;
  final String label;
  final TextEditingController? controller;

  const TimePicker({
    Key? key,
    this.controller,
    this.onTap,
    required this.label,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimePicker();
  }
}

class _TimePicker extends State<TimePicker> {
  TextEditingController timeinput = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    super.initState();
    timeinput.text = ""; //set the initial value of text field
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: TextField(
          controller: widget.controller, //editing controller of this TextField
          decoration: InputDecoration(
            labelText: widget.label,
            //label text of field
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          readOnly: true, //set it true, so that user will not able to edit text
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
