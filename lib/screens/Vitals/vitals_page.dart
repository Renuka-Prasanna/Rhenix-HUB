import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:precision_hub/screens/Login/login_page.dart';
import 'package:precision_hub/screens/Vitals/fetch_vitals.dart';
import 'package:precision_hub/screens/qr_scan_page.dart';
import 'package:precision_hub/utils/use_12_hour_format.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/custom_widgets/auth_button.dart';
import 'package:precision_hub/widgets/custom_widgets/date_picker.dart';
import 'package:precision_hub/widgets/custom_widgets/heading.dart';
import 'package:precision_hub/widgets/custom_widgets/home_top_splash.dart';
import 'package:precision_hub/widgets/custom_widgets/left_text_box.dart';
import 'package:precision_hub/widgets/custom_widgets/nav_drawer.dart';
import 'package:precision_hub/widgets/custom_widgets/time_picker.dart';

import '../Code/Code.dart';
import 'package:get/get.dart' as getx;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = UserProvider();
  var phoneVitals;
  final _storage = const FlutterSecureStorage();

  static double gapBetweenTextWidgets = 5;

  //controllers
  TextEditingController systolic = TextEditingController();
  TextEditingController diastolic = TextEditingController();
  TextEditingController heartRate = TextEditingController();
  TextEditingController sugarLevel = TextEditingController();

  TextEditingController vitalDate = TextEditingController();
  TextEditingController vitalTime = TextEditingController();

  TextEditingController vitaldateinput = TextEditingController();
  TextEditingController vitaltimeinput = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getuser().then(
      (id) {
        setState(() {});
      },
    );
    //set the initial value of inputs
    vitaldateinput.text = DateFormat('MMMM d, y').format(DateTime.now()).toString();
    vitaltimeinput.text = DateFormat('h:mm a').format(DateTime.now()).toString();
    vitalDate.text = vitaldateinput.text;
    vitalTime.text = vitaltimeinput.text;
    systolic.text = "";
    diastolic.text = "";
    sugarLevel.text = "";
    heartRate.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        bottomOpacity: -1.0,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const QRViewExample();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('You want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Yes, Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          user.signOut();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return const Code();
                          //     },
                          getx.Get.offAll(() => Code());
                        },
                      ),
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: const NavDrawer(),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            const HomeTopSplash(imagePath: 'assets/images/curescience_logo.png'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            const Heading(buttonText: "Vitals"),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Padding(
              padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.03, 0, MediaQuery.of(context).size.height * 0.03, 0),
              child: const Text(
                "NORMAL BP: 120/80 mmHg",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: LeftTextField(
                    labelText: 'Systolic (Ex:120)',
                    keyboardType: TextInputType.number,
                    controller: systolic,
                    validator: (systolic) {
                      if (systolic != "") {
                        if (int.parse(systolic!) > 200 || int.parse(systolic) < 60) {
                          return 'Please enter valid value(60-200)';
                        } else {
                          return null;
                        }
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  child: LeftTextField(
                    labelText: 'Diastolic (Ex:80)',
                    keyboardType: TextInputType.number,
                    controller: diastolic,
                    validator: (diastolic) {
                      if (diastolic != "") {
                        if (int.parse(diastolic!) > 100 || int.parse(diastolic) < 20) {
                          return 'Please enter valid value(20-100)';
                        } else {
                          return null;
                        }
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: LeftTextField(
                  labelText: 'Heart Rate (per min)',
                  keyboardType: TextInputType.number,
                  controller: heartRate,
                  validator: (heartRate) {
                    if (heartRate != "") {
                      if (int.parse(heartRate!) > 100 || int.parse(heartRate) < 20) {
                        return 'Please enter valid value(20-100)';
                      } else {
                        return null;
                      }
                    }
                    return null;
                  },
                )),
                Expanded(
                    child: LeftTextField(
                  labelText: 'Sugar Level (mmol/L)',
                  keyboardType: TextInputType.number,
                  controller: sugarLevel,
                  validator: (sugarLevel) {
                    if (sugarLevel != "") {
                      if (int.parse(sugarLevel!) > 200 || int.parse(sugarLevel) < 40) {
                        return 'Please enter valid value(40-200)';
                      } else {
                        return null;
                      }
                    }
                    return null;
                  },
                ))
              ],
            ),
            SizedBox(height: gapBetweenTextWidgets),
            const Heading(buttonText: 'Date and Time'),
            SizedBox(height: gapBetweenTextWidgets),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DatePicker(
                    label: "Date",
                    circularRadius: MediaQuery.of(context).size.height * 0.02,
                    onTap: () async {
                      DateTime? pickedDate =
                          await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime.now());

                      if (pickedDate != null) {
                        String formattedDate = DateFormat('MMMM d, y').format(pickedDate);

                        setState(() {
                          vitaldateinput.text = formattedDate;
                          vitalDate = vitaldateinput;
                          //set output date to TextField value.
                        });
                      } else {}
                    },
                    controller: vitaldateinput,
                  ),
                ),
                Expanded(
                  child: TimePicker(
                    label: "Time",
                    controller: vitaltimeinput,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                            child: child ?? Container(),
                          );
                        },
                      );

                      if (pickedTime != null) {
                        String pickTimeIn24hrFormat = use12HourFormat(pickedTime, MaterialLocalizations.of(context));

                        DateTime parsedTime = DateFormat.jm().parse(pickTimeIn24hrFormat);
                        String formattedTime = DateFormat("h:mm a").format(parsedTime);

                        setState(
                          () {
                            vitaltimeinput.text = formattedTime;
                            vitalTime = vitaltimeinput;
                          },
                        );
                      } else {}
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            AuthButton(
              buttonText: "Save",
              leftPadding: MediaQuery.of(context).size.height * 0.03,
              rightPadding: MediaQuery.of(context).size.height * 0.03,
              onPressed: () async {
                if (validateForm() &&
                    _formKey.currentState!.validate() &&
                    await user.vitals(
                          phoneVitals,
                          systolic.text == "" ? "0" : systolic.text,
                          diastolic.text == "" ? "0" : diastolic.text,
                          sugarLevel.text == "" ? "0" : sugarLevel.text,
                          heartRate.text == "" ? "0" : heartRate.text,
                          vitalDate.text,
                          vitalTime.text,
                        ) ==
                        true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Saved Successfully",
                      ),
                    ),
                  );
                  setState(() {
                    clearForm();
                  });
                  setState(() {});
                }
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            AuthButton(
                buttonText: "History",
                onPressed: () {
                  setState(() {
                    clearForm();
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FetchVitals(
                            phone: phoneVitals,
                          )));
                },
                leftPadding: MediaQuery.of(context).size.height * 0.03,
                rightPadding: MediaQuery.of(context).size.height * 0.03)
          ],
        ),
      ),
    );
  }

  bool validateForm() {
    if ((systolic.text == "" && diastolic.text != "") || (systolic.text != "" && diastolic.text == "")) {
      Fluttertoast.showToast(
          msg: "Please enter both Systolic and Diastolic Values",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    if ((systolic.text != "" && diastolic.text != "") || (heartRate.text) != "" || (sugarLevel.text) != "") {
      return true;
    }
    Fluttertoast.showToast(
        msg: "Please enter atleast one of the field",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    return false;
  }

  void clearForm() {
    systolic.clear();
    diastolic.clear();
    heartRate.clear();
    sugarLevel.clear();
    vitalDate.text = DateFormat('MMMM d, y').format(DateTime.now()).toString();
    vitalTime.text = DateFormat('h:mm a').format(DateTime.now()).toString();
  }

  getuser() async {
    final currentUser = await _storage.readAll();
    phoneVitals = currentUser['Phone'];
  }
}
