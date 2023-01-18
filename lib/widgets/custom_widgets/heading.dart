import 'package:flutter/material.dart';

class Heading extends StatefulWidget {
  final String buttonText;
  const Heading({Key? key, required this.buttonText}) : super(key: key);

  @override
  State<Heading> createState() => _HeadingState();
}

class _HeadingState extends State<Heading> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
          ), // <-- Wrapped in Expanded.
        ),
      ],
    );
  }
}
