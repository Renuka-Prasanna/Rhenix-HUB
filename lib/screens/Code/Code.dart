import 'package:precision_hub/screens/Code/AppRoutes.dart';
import 'package:precision_hub/screens/Code/company.dart';
import 'package:flutter/material.dart';
import 'package:precision_hub/screens/Login/login_page.dart';
import 'package:precision_hub/screens/Vitals/vitals_page.dart';
import 'package:precision_hub/screens/Registration/registration_page.dart';

import '../../widgets/custom_widgets/top_splash.dart';
import '../Login/login_with_code.dart';
import 'dynamiclinks.dart';

void main() => runApp(const Code());

class Code extends StatelessWidget {
  const Code({Key? key}) : super(key: key);

  static const String _title = ' ';

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      onGenerateRoute: RouteManager.generateRoute,
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ListView(
          children: <Widget>[
            const TopSplashWidget(imagePath: 'assets/images/curescience_logo.png'),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Welcome to SmartHub',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 24),
                )),
            SizedBox(height: 15.0),
            // Container(
            //     alignment: Alignment.center,
            //     padding: const EdgeInsets.all(20),
            //     child: const Text(
            //       'Have Code',
            //       style: TextStyle(fontSize: 25,
            //       fontWeight: FontWeight.w500 ,
            //       color: Colors.black54),
            //     )),
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   child: TextField(
            //     controller: nameController,
            //     decoration: const InputDecoration(
            //       border: OutlineInputBorder(),
            //       labelText: 'Enter your Code',
            //     ),
            //   ),
            // ),
            SizedBox(height: 30.0),
            Container(
                height: 80,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: const Text('Login with Code',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    print(nameController.text);
                    // if(nameController.text == "C1"){
                    //   Navigator.pushNamed(context,AppRoutes.companyScreen);}
                    // else if(nameController.text == "C2"){
                    //   Navigator.pushNamed(context,AppRoutes.companyScreen2);
                    // }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPageCode()),
                    );
                  },
                )
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text(
                  'OR',
                  style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w500 ,
                      color: Colors.black54),
                )),
            Container(
                height: 80,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: const Text('Login with OTP',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    print(nameController.text);
                    // if(nameController.text == "C1"){
                    //   Navigator.pushNamed(context,AppRoutes.companyScreen);}
                    // else if(nameController.text == "C2"){
                    //   Navigator.pushNamed(context,AppRoutes.companyScreen2);
                    // }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                  },
                )
            ),
            // Container(
            //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            //   child: TextField(
            //     obscureText: true,
            //     controller: passwordController,
            //     keyboardType: TextInputType.number,
            //     decoration: const InputDecoration(
            //       border: OutlineInputBorder(),
            //
            //       labelText: 'Enter PhoneNumber',
            //     ),
            //   ),
            // ),
            // TextButton(
            //   onPressed: () {
            //     //forgot password screen
            //   },
            //   child: const Text('Forgot Password or Code',
            //     style: TextStyle(color: Colors.blueGrey),
            //   ) ),
            // Container(
            //     height: 50,
            //     padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           primary: Colors.grey,
            //           ),
            //       child: const Text('Submit',
            //             style: TextStyle(color: Colors.white),
            //       ),
            //       onPressed: () {
            //         print(nameController.text);
            //         if(nameController.text == "C1"){
            //           Navigator.pushReplacement(
            //             context,
            //             MaterialPageRoute(builder: (context) => const HomePage()),
            //           );}
            //         else if(nameController.text == "C2"){
            //           Navigator.pushReplacement(
            //             context,
            //             MaterialPageRoute(builder: (context) => const HomePage()),
            //           );
            //         }
            //       },
            //     )
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have Code?'),
                TextButton(
                  child: const Text(
                    'Create one',
                    style: TextStyle(fontSize: 20,
                    color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationPage()),
                    );
                    //signup screen
                  },
                )
              ],
            ),
          ],
        ));
  }
}