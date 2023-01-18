import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:precision_hub/screens/Code/Code.dart';
import 'AppRoutes.dart';

String _textString = 'Not Found' ;
String text = '';
String code = '';

class signUp extends StatefulWidget{
  const signUp({super.key});
  @override
  _SigninScreenState createState() => _SigninScreenState();
}
class _SigninScreenState extends State<signUp> {

  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          // child: Text(
          //   'Welcome to CompanyScreen1',
          //   style: TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.w700,
          //       fontSize: 20),
          // ),
          child: ListView(
           children: <Widget>[
             Container(
                 alignment: Alignment.center,
                 padding: const EdgeInsets.all(30),
                 child: const Text(
                   'Welcome to Precision Hub',
                   style: TextStyle(
                       color: Colors.grey,
                       fontWeight: FontWeight.w700,
                       fontSize: 20),
                 )),
                Container(
              padding: const EdgeInsets.all(10),
                child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
              border: OutlineInputBorder(),
             labelText: 'Enter your CompanyName',
               ),
          ),
        ),
          Container(
           padding: const EdgeInsets.all(10),
            child: TextField(
            controller: idController,
            decoration: const InputDecoration(
           border: OutlineInputBorder(),
            labelText: 'Enter your ID',
              ),
           ),
       ),
         // Container(
         //     padding: const EdgeInsets.all(10),
         //         child: TextField(
         //     controller: passwordController,
         //      decoration: const InputDecoration(
         //       border: OutlineInputBorder(),
         //       labelText: 'Password',
         //    ),
         //       ),
         //    ),

           Container(
             height: 50,
             padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                 child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
            primary: Colors.grey,
                 ),
            child: const Text('Submit',
            style: TextStyle(color: Colors.white),
            ),

            onPressed: () {
              text= nameController.text;
              code = idController.text;
              _doSomething();
                      // showCode;
             // String code = nameController.text;
             //  Container(
             //      alignment: Alignment.center,
             //      padding: const EdgeInsets.all(40),
             //      child: Text(
             //       "Your Code is $code",
             //        style: TextStyle(
             //            color: Colors.black,
             //            fontWeight: FontWeight.w700,
             //            fontSize: 24),
             //      ));
              // // print(nameController.text);
              // if(nameController.text == "C1"){
              // Navigator.pushNamed(context,AppRoutes.companyScreen);}
              // else if(nameController.text == "C2"){
              // Navigator.pushNamed(context,AppRoutes.companyScreen2);
              },
          )
          ),
             Container(
                 alignment: Alignment.center,
                 padding: const EdgeInsets.all(80),
                 child: Text(
                   _textString,
                   style: TextStyle(
                       color: Colors.black,
                       fontWeight: FontWeight.w700,
                       fontSize: 15),
                 )),
          ]
          )),


    );

  }

  void _doSomething() {
    // Using the callback State.setState() is the only way to get the build
    // method to rerun with the updated state value.
    setState(() {
      if(code.isEmpty || text.isEmpty){
        _textString = "Not Found";
      }
      else{_textString = "Your code is $text$code";}
    });
  }
}
