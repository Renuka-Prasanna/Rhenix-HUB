import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:precision_hub/screens/Login/login_page.dart';
import 'package:precision_hub/screens/Code/Code.dart';

class Splash2 extends StatefulWidget {
  const Splash2({Key? key}) : super(key: key);

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: const CircleAvatar(
        backgroundImage: AssetImage("assets/images/curescience_logo.png"),
        backgroundColor: Colors.white,
        radius: 80,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      nextScreen: const Code(),
      splashIconSize: 150,
      duration: 1000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
