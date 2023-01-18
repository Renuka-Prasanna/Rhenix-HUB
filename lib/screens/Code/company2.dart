import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//
// Widget build(BuildContext context) {
//
//   return MaterialApp(
//       home: Scaffold(
//       body: companyScreen(),
//       )
//   );
// }
class companyScreen2 extends StatefulWidget{
  // const companyScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState1 createState() => _LoginScreenState1();
}
class _LoginScreenState1 extends State<companyScreen2> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Welcome to CompanyScreen2',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20),
          )),
    );
  }
}