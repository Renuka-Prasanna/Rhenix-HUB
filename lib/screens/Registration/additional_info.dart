import 'package:flutter/material.dart';
import 'package:precision_hub/screens/Registration/height_weight_picker.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/custom_widgets/auth_button.dart';
import 'package:precision_hub/widgets/custom_widgets/weight_picker.dart';
import 'package:precision_hub/widgets/health_records/header_text.dart';

class AdditionalDetails extends StatefulWidget {
  final String headerText;
  final String buttonText;
  final Widget destWidget;
  final String phone;
  const AdditionalDetails({Key? key, required this.phone, required this.headerText, required this.buttonText, required this.destWidget})
      : super(key: key);

  @override
  State<AdditionalDetails> createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  final user = UserProvider();

  //controllers
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController fieldText = TextEditingController();

  //height controllers
  String heightUnit = 'm/cm';
  String feet = "";
  String inch = "";
  String meter = "";
  String cm = "";

  //weight unit
  String weightUnit = 'kg';

  //height unit
  static List<String> heightList = ['ft/in', 'm/cm'];
  String heightTypeCurrentValue = heightList[1];

  //height unit values
  static List<String> feetList = ['2', '3', '4', '5', '6', '7', '8'];
  String feetCurrentValue = feetList[0];

  static List<String> inchList = List<String>.generate(12, (i) => "$i");
  String inchCurrentValue = inchList[0];

  static List<String> meterList = ['1', '2', '3', '4'];
  String meterCurrValue = meterList[0];

  static List<String> cmList = List<String>.generate(100, (i) => "$i");
  String cmCurrValue = cmList[0];

  //weight unit list
  static List<String> weightList = ['kg', 'lbs'];
  String weightCurrentValue = weightList[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AlertDialog(
        insetPadding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        scrollable: true,
        alignment: Alignment.center,
        title: HeaderText(widget.headerText),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: Column(
              children: <Widget>[
                const HeaderText("Height"),
                HeightWeightPicker(
                  heightTypeCurrentValue: heightTypeCurrentValue,
                  onChanged: (String? newValue) => {
                    if (mounted)
                      {
                        setState(
                          () {
                            clearText();
                            heightTypeCurrentValue = newValue ?? heightTypeCurrentValue;
                            heightUnit = heightTypeCurrentValue;
                          },
                        ),
                      }
                  },
                  feetCurrentValue: feetCurrentValue,
                  onChangedFeet: (String? newValue) => {
                    if (mounted)
                      {
                        setState(
                          () {
                            clearText();
                            feetCurrentValue = newValue ?? feetCurrentValue;
                            if (heightUnit == 'ft/in') {
                              feet = feetCurrentValue;
                            }
                          },
                        ),
                      }
                  },
                  inchCurrentValue: inchCurrentValue,
                  onChangedInch: (String? newValue) => {
                    if (mounted)
                      {
                        setState(
                          () {
                            inchCurrentValue = newValue ?? inchCurrentValue;
                            if (heightUnit == 'ft/in') {
                              inch = inchCurrentValue;
                            }
                          },
                        ),
                      }
                  },
                  meterCurrValue: meterCurrValue,
                  onChangedMeter: (String? newValue) => {
                    if (mounted)
                      {
                        setState(
                          () {
                            meterCurrValue = newValue ?? meterCurrValue;
                            if (heightUnit == 'm/cm') {
                              meter = meterCurrValue;
                            }
                          },
                        ),
                      }
                  },
                  cmCurrValue: cmCurrValue,
                  onChangedCm: (String? newValue) => {
                    if (mounted)
                      {
                        setState(
                          () {
                            cmCurrValue = newValue ?? cmCurrValue;
                            if (heightUnit == 'm/cm') {
                              cm = cmCurrValue;
                            }
                          },
                        ),
                      }
                  },
                ),
                const HeaderText("Weight"),
                WeightPicker(
                  editValue: weightCurrentValue,
                  onChanged: (String? newValue) => {
                    if (mounted)
                      {
                        setState(
                          () {
                            weightCurrentValue = newValue ?? weightCurrentValue;
                            weightUnit = weightCurrentValue;
                          },
                        ),
                      }
                  },
                  controllerWeight: weight,
                ),
              ],
            ),
          ),
        ),
        actions: [
          AuthButton(
            buttonText: widget.buttonText,
            leftPadding: 20,
            rightPadding: 40,
            onPressed: () async {
              if (await user.additionalInfo(
                    widget.phone,
                    heightUnit,
                    weightUnit,
                    feet,
                    inch,
                    meter,
                    cm,
                    weight.text,
                  ) ==
                  true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Saved Successfully",
                    ),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return widget.destWidget;
                    },
                  ),
                );
                setState(() {
                  clearForm();
                });
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }

  void clearText() {
    fieldText.clear();
  }

  void clearForm() {
    weight.clear();
  }
}
