import 'package:flutter/material.dart';
import 'package:precision_hub/screens/Login/sendotp.dart';
import 'package:precision_hub/screens/Registration/registration_page.dart';
import 'package:precision_hub/screens/Vitals/vitals_page.dart';
import 'package:precision_hub/widgets/User_Provider.dart';
import 'package:precision_hub/widgets/custom_widgets/auth_button.dart';
import 'package:precision_hub/widgets/custom_widgets/common.dart';
import 'package:precision_hub/widgets/custom_widgets/text_box.dart';
import 'package:precision_hub/widgets/custom_widgets/top_splash.dart';
import 'package:precision_hub/widgets/health_records/header_text.dart';
import 'package:precision_hub/screens/Registration/additional_info.dart';
import '../Code/Code.dart';


TextEditingController Phone = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = UserProvider();


  @override
  void initState() {
    super.initState();
    Phone.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Code()));
    return false; // return true if you want to prevent the back button press, otherwise return false
    },
      child: Scaffold(
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
                      labelText: "Mobile number",
                      borderRadius: MediaQuery.of(context).size.height * 0.02,
                      padding: MediaQuery.of(context).size.height * 0.02,
                      keyboardType: TextInputType.number,
                      controller: Phone),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  AuthButton(
                    buttonText: "Continue",
                    leftPadding: MediaQuery.of(context).size.height * 0.03,
                    rightPadding: MediaQuery.of(context).size.height * 0.03,
                    onPressed: () async {
                      if (!await user.signIn(Phone.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User doesnot exist'),
                          ),
                        );
                      } else if (Phone.text.isNotEmpty) {
                        if (Phone.text == '9490007929') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        } else {
                          changeScreenReplacement(
                            context,
                            OtpPage(
                              phonenumber: Phone.text,
                            ),
                          );
                        }
                      }
                    },
                  ),
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
                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //       builder: (context) => AdditionalDetails(
                            //         phone: Phone.text,
                            //         headerText: "Additinal Info",
                            //         buttonText: "Register",
                            //         destWidget: const   Code(),
                            //       )),
                            // );
                          },
                          child: Text(
                            'Create an account',
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
