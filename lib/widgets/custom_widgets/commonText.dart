import 'package:flutter/material.dart';

class CommonText extends StatefulWidget {
  String text;
  FontWeight? fontWeight;
  CommonText({Key? key, required this.text, this.fontWeight}) : super(key: key);

  @override
  State<CommonText> createState() => _CommonTextState();
}

class _CommonTextState extends State<CommonText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.text,
          style: TextStyle(fontWeight: widget.fontWeight),
        ),
      ),
    );
  }
}
