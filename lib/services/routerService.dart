import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ramo/pages/signinpage.dart';
import 'package:ramo/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case '/signup': 
        return MaterialPageRoute(builder: (_) => SignInPage());
      case '/home': 
        return MaterialPageRoute(builder: (_) => MyApp());
      default:
        return MaterialPageRoute(builder: (_) => MyApp());
    }
  }
}

