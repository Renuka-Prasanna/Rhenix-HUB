import 'package:precision_hub/screens/Code/signUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AppRoutes.dart';
import 'company.dart';
import 'company2.dart';

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //paths takes the URL and splits its parameters based on "?" mark
    final paths = settings.name?.split("?");
    //Using paths split length we separate arguments in the URL.
    final args = paths?.length == 2 ? Uri.splitQueryString(paths![1]) : null;
    switch (paths![0]) {
      case AppRoutes.companyScreen:
        return MaterialPageRoute(
          settings: RouteSettings(name: AppRoutes.companyScreen),
          builder: (context) => companyScreen()
        );
        break;
      case AppRoutes.companyScreen2:
        return MaterialPageRoute(
            settings: RouteSettings(name: AppRoutes.companyScreen2),
            builder: (context) => companyScreen2()
        );
        break;
      case AppRoutes.signUp:
        return MaterialPageRoute(
            settings: RouteSettings(name: AppRoutes.signUp),
            builder: (context) => signUp()
        );
        break;
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute(paths.toString());
        break;
    }
    }
  static Route<dynamic> _errorRoute(String name) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error in Navigation'),
        ),
        body: Center(
          child: Text('$name'),
        ),
      );
    });
  }


}
