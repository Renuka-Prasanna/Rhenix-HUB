import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:precision_hub/screens/Login/sendotp.dart';
import 'package:precision_hub/screens/Registration/registration_page.dart';
import 'package:precision_hub/screens/Vitals/vitals_page.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/custom_widgets/auth_button.dart';
import 'package:precision_hub/widgets/custom_widgets/common.dart';
import 'package:precision_hub/widgets/custom_widgets/text_box.dart';
import 'package:precision_hub/widgets/custom_widgets/top_splash.dart';
import 'package:precision_hub/widgets/health_records/header_text.dart';
import 'package:precision_hub/screens/Registration/registration_page.dart';

import '../Code/Code.dart';

class LoginPageCode extends StatefulWidget {
  const LoginPageCode({Key? key}) : super(key: key);

  @override
  State<LoginPageCode> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageCode> {
  final user = UserProvider();
  TextEditingController finalcode = TextEditingController();

  @override
  void initState() {
    super.initState();
    finalcode.text= "";
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Code()));
          return false; // return true if you want to prevent the back button press, otherwise return false
    },
      child : Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const TopSplashWidget(imagePath: 'assets/images/curescience_logo.png'),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Card(
            shadowColor: Theme.of(context).primaryColor,
            elevation: 5,
            margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.03)),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  const HeaderText("Login"),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  BorderedTextField(
                      labelText: "Enter code",
                      borderRadius: MediaQuery.of(context).size.height * 0.02,
                      padding: MediaQuery.of(context).size.height * 0.02,
                      keyboardType: TextInputType.text,
                      controller: finalcode),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  AuthButton(
                    buttonText: "Continue",
                    leftPadding: MediaQuery.of(context).size.height * 0.03,
                    rightPadding: MediaQuery.of(context).size.height * 0.03,
                    onPressed: () async {
                      var orCode = finalcode.text.replaceAll(RegExp('[^0-9]'),'');
                      print("-----------here is the code==============");
                      print(orCode);
                      if (!await user.signInCode(orCode)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User doesnot exist'),
                          ),
                        );
                      } else if (orCode.isNotEmpty) {
                        if (orCode == '9490007929') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        }
                        else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                          Fluttertoast.showToast(
                              msg: "Login successful",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    },
                  ),
                  // AuthButton(
                  //   buttonText: "Continue",
                  //   leftPadding: MediaQuery.of(context).size.height * 0.03,
                  //   rightPadding: MediaQuery.of(context).size.height * 0.03,
                  //   onPressed: () async {
                  //     var orCode = finalcode.text.replaceAll(RegExp('[^0-9]'),'');
                  //     print("-----------here is the code==============");
                  //     print(orCode);
                  //     if (!await user.signInCode(orCode)) {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(
                  //           content: Text('User doesnot exist'),
                  //         ),
                  //       );
                  //     } else if (finalcode.text.isNotEmpty) {
                  //       if (finalcode.text == '9490007929') {
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => const HomePage()),
                  //         );
                  //       }
                  //       else {
                  //         // changeScreenReplacement(
                  //         //   context,
                  //         //   OtpPage(
                  //         //     phonenumber: Phone.text,
                  //         //   ),
                  //         // );
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => const HomePage()),
                  //         );
                  //       }
                  //     }
                  //   },
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.07,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('New user? '),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationPage()));
                          },
                          child: Text(
                            'Create a code',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),);
  }
}
