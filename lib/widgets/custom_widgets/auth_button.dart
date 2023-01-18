import 'package:flutter/material.dart';

class AuthButton extends StatefulWidget {
  final String buttonText;
  final Function onPressed;
  final double leftPadding;
  final double rightPadding;

  const AuthButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.leftPadding,
    required this.rightPadding,
  }) : super(key: key);

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(widget.leftPadding, 0, widget.rightPadding, 0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            child: Text(widget.buttonText),
            onPressed: () {
              widget.onPressed();
            },
          ),
        ));
  }
}
