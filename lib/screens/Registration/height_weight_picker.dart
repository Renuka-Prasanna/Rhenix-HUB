import 'package:flutter/material.dart';

TextEditingController heightUnit = TextEditingController();

class HeightWeightPicker extends StatefulWidget {
  final Function(String?) onChanged;
  String heightTypeCurrentValue;

  final Function(String?) onChangedFeet;
  String feetCurrentValue;

  final Function(String?) onChangedInch;
  String inchCurrentValue;

  final Function(String?) onChangedMeter;
  String meterCurrValue;

  final Function(String?) onChangedCm;
  String cmCurrValue;

  HeightWeightPicker({
    Key? key,
    required this.onChanged,
    required this.heightTypeCurrentValue,
    required this.onChangedFeet,
    required this.feetCurrentValue,
    required this.onChangedInch,
    required this.inchCurrentValue,
    required this.onChangedMeter,
    required this.meterCurrValue,
    required this.onChangedCm,
    required this.cmCurrValue,
  }) : super(key: key);

  @override
  State<HeightWeightPicker> createState() => _HeightWeightPickerState();
}

class _HeightWeightPickerState extends State<HeightWeightPicker> {
  static List<String> heightList = ['m/cm', 'ft/in'];

  static List<String> feetList = ['2', '3', '4', '5', '6', '7', '8'];

  static List<String> inchList = List<String>.generate(12, (i) => "$i");

  static List<String> meterList = ['1', '2', '3', '4'];

  static List<String> cmList = List<String>.generate(100, (i) => "$i");

  @override
  void initState() {
    super.initState();
    heightUnit.text = ""; //set the initial value of text field
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(0.9),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...heightInputWidgets(),
                  Expanded(
                    child: dropDown(
                      1,
                      16,
                      heightList,
                      const Text("Units"),
                      widget.heightTypeCurrentValue,
                      (String? newValue) {
                        setState(() {
                          widget.heightTypeCurrentValue = newValue ?? widget.heightTypeCurrentValue;
                        });
                        widget.onChanged(newValue);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> heightInputWidgets() {
    if (widget.heightTypeCurrentValue == 'ft/in') {
      return [
        Expanded(
          child: dropDown(
            1,
            16,
            feetList,
            const Text('Feet'),
            widget.feetCurrentValue,
            (String? newValue) {
              setState(() {
                widget.feetCurrentValue = newValue ?? widget.feetCurrentValue;
              });
              widget.onChangedFeet(newValue);
            },
          ),
        ),
        Expanded(
          child: dropDown(
            1,
            16,
            inchList,
            const Text('Inch'),
            widget.inchCurrentValue,
            (String? newValue) {
              setState(() {
                widget.inchCurrentValue = newValue ?? widget.inchCurrentValue;
              });
              widget.onChangedInch(newValue);
            },
          ),
        ),
      ];
    }
    return [
      Expanded(
        child: dropDown(
          10,
          15,
          meterList,
          const Text('Meter'),
          widget.meterCurrValue,
          (String? newValue) {
            setState(() {
              widget.meterCurrValue = newValue ?? widget.meterCurrValue;
            });
            widget.onChangedMeter(newValue);
          },
        ),
      ),
      Expanded(
        child: dropDown(
          1,
          1,
          cmList,
          const Text('CentiMeter'),
          widget.cmCurrValue,
          (String? newValue) {
            setState(() {
              widget.cmCurrValue = newValue ?? widget.cmCurrValue;
            });
            widget.onChangedCm(newValue);
          },
        ),
      ),
    ];
  }

  Widget dropDown(
      double leftAndRightPadding, double borderRadius, List<String> dropdownItems, Widget hint, String currentValue, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.all(leftAndRightPadding),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: EdgeInsets.only(
              left: leftAndRightPadding,
              right: leftAndRightPadding,
              top: 4,
              bottom: 4,
            ),
            child: DropdownButton(
              hint: hint,
              value: currentValue,
              isExpanded: true,
              items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
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
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
