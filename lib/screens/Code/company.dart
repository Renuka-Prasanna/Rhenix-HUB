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
class companyScreen extends StatefulWidget{
  // const companyScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<companyScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
    @override
  Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
            child: Text(
              'Welcome to CompanyScreen1',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
      )),
        );
    }
}