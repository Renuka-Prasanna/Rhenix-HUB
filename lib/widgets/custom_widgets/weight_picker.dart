import 'package:flutter/material.dart';
import 'package:precision_hub/widgets/custom_widgets/edit_drop_down.dart';
import 'package:precision_hub/widgets/custom_widgets/text_box.dart';

//TextEditingController fieldText = TextEditingController();
//TextEditingController weightUnit = TextEditingController();

class WeightPicker extends StatefulWidget {
  final Function(String?) onChanged;

  TextEditingController controllerWeight = TextEditingController();
  String? editValue;

  WeightPicker({Key? key, required this.onChanged, required this.controllerWeight, this.editValue}) : super(key: key);

  @override
  State<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  static List<String> weightList = ['kg', 'lbs'];
  String weightCurrentValue = weightList[0];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: BorderedTextField(
                      labelText: "Weight",
                      borderRadius: 15,
                      padding: 10,
                      keyboardType: TextInputType.number,
                      controller: widget.controllerWeight,
                    ),
                  ),
                  Expanded(
                    child: EditDropDown(
                      editValue: widget.editValue,
                      leftAndRightPadding: 10,
                      borderRadius: 15,
                      dropdownItems: weightList,
                      hint: const Text("Unit"),
                      onPressed: widget.onChanged,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
