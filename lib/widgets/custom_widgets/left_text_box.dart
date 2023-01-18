import 'dart:ui';

import 'package:flutter/material.dart';

class LeftTextField extends StatefulWidget {
  final String? labelText;
  final String? initialvalue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? errorText;

  const LeftTextField({
    Key? key,
    this.labelText,
    this.initialvalue,
    this.controller,
    this.keyboardType,
    this.validator,
    this.errorText,
  }) : super(key: key);

  @override
  State<LeftTextField> createState() => _LeftTextFieldState();
}

class _LeftTextFieldState extends State<LeftTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        initialValue: widget.initialvalue,
        validator: widget.validator,
        decoration: InputDecoration(
          errorText: widget.errorText,
          labelText: widget.labelText,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
