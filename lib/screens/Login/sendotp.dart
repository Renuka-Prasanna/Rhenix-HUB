import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:http/http.dart';
import 'package:precision_hub/fetchfunctions/get_code.dart';
import 'package:precision_hub/screens/Registration/registration_page.dart';
import 'package:precision_hub/screens/Vitals/vitals_page.dart';
import 'dart:convert';

import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/custom_widgets/common.dart';

import 'login_page.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

late String phone = "";
late String code = "";
late String zipcode;
Color resendCodecolor = Colors.black;
var newotp = '----';

class OtpPage extends StatefulWidget {
  final phonenumber;
  const OtpPage({this.phonenumber});
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final user = UserProvider();

  TextEditingController otpverify = TextEditingController();
  bool startTimer = false;
  String textOnButton = "Send OTP";
  bool isSendOtpPressed = false;
  bool onTimerEnds = false;
  bool isButtonDisabled = false;
  bool isResendButtonDisabled = false;
  late Widget resendButton;

  bool resultChecker(String enteredOtp) {
    return enteredOtp == newotp;
  }

  @override
  void initState() {
    super.initState();
    phone = widget.phonenumber;
    getcode(phone);
  }

  @override
  void dispose() {
    //SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
      return false; // return true if you want to prevent the back button press, otherwise return false
    },
      child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: _scaffoldKey,
      body: Center(
        child: Card(
          shadowColor: Theme.of(context).primaryColor,
          elevation: 5,
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                Icon(Icons.message, size: 50, color: Theme.of(context).primaryColor),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Verification Code',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Enter your OTP",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  child: PinInputTextField(
                    controller: otpverify,
                    pinLength: 4,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (onTimerEnds)
                        ? MaterialButton(
                            child: Ink(
                              decoration: BoxDecoration(color: Colors.orange.shade300, borderRadius: BorderRadius.circular(25.0)),
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 120.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: const [
                                    Text(
                                      "Resend OTP",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Montserrat'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onPressed: () {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text('OTP sent successfully'),
                              //   ),
                              // );
                              (isResendButtonDisabled) ? () {} : sendotpnew(phone);
                              Fluttertoast.showToast(
                                  msg: "OTP sent successfully",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              setState(() {
                              });
                            },
                          )
                        : MaterialButton(
                            child: Ink(
                              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(25.0)),
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 140.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Send OTP",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Montserrat'),
                                    ),
                                    isSendOtpPressed ? getTimer() : const Text(""),
                                  ],
                                ),
                              ),
                            ),
                            onPressed: () {
                              (isButtonDisabled) ? () {} : sendotpnew(phone);
                              print("Sent otp successfully");
                              Fluttertoast.showToast(
                                  msg: "OTP sent successfully",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              setState(() {
                                isButtonDisabled = true;
                                isSendOtpPressed = true;
                                Timer(const Duration(seconds: 10), () => onTimerEnds = true);
                              });
                            },
                          ),
                    MaterialButton(
                      child: Ink(
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(25.0)),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: const Text(
                            "Verify OTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                      onPressed: () {
                        bool isCorrectOTP = resultChecker(otpverify.text);
                        if (isCorrectOTP) {
                          user.confirmed(phone);
                          Timer(const Duration(seconds: 2), () {
                            changeScreenReplacement(context, const HomePage());
                            Fluttertoast.showToast(
                                msg: "Login successful",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Your OTP is incorrect'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => const LoginPage()),
                                      // );
                                      print('--hello this is opt');
                                      print(otpverify);
                                      //otpverify.dispose();
                                      // cleartext();
                                      Navigator.of(context).pop('login_page');
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          print("not verified");
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget getTimer({bool isTimerEnd = false}) {
    return TweenAnimationBuilder<Duration>(
      duration: const Duration(seconds: 15),
      tween: Tween(begin: const Duration(seconds: 15), end: Duration.zero),
      onEnd: () {
        setState(() {
          isTimerEnd = true;
        });
      },
      builder: (BuildContext context, Duration value, Widget? child) {
        final minutes = value.inMinutes;
        final seconds = value.inSeconds % 60;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            '$minutes:$seconds',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        );
      },
    );
  }
}

void getcode(number) async {
  Uri url = Uri.parse('https://dors1qol6j.execute-api.ap-south-1.amazonaws.com/Seniorcitizen_Countrycode/');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"phone_number": "$number" }';
  Response response = await post(url, headers: headers, body: json);
  var list = jsonDecode(response.body);
  code = list[0]["Country_Code"];
  print("New Otp entered -------------------------------");
  print(code);
  zipcode = list[0]["Zipcode"];
}


void sendotpnew(String number) async {
  Uri url = Uri.parse('https://gitpao19gl.execute-api.ap-south-1.amazonaws.com/Seniorcitizen_Sendotp/');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"phone_number": "$number", "countrycode":"$code" }';
  // print("Sent otp");
  print("$number");
  print("$code");
  Response response = await post(url, headers: headers, body: json);
  print(response.body);
  var list = jsonDecode(response.body);
  newotp = list['body'].toString();
  print(newotp);
}


