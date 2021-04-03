import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ramo/pages/auth/signinpage.dart';
import 'package:ramo/pages/auth/signuppage.dart';
import 'package:ramo/pages/auth/accountsetup.dart';
import 'package:ramo/pages/auth/testmap.dart';
import 'package:ramo/main.dart';
import 'package:ramo/pages/onboarding/onboarding.dart';
import 'package:ramo/pages/dev/devhome.dart';
import 'package:ramo/pages/dev/camera.dart';
import 'package:ramo/pages/dev/checkbox1.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/signin':
        return MaterialPageRoute(builder: (_) => SignInPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => MyApp());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => Onboarding());
      case '/accsetup':
        return MaterialPageRoute(builder: (_) => AccountSetup());
      case '/devmap':
        return MaterialPageRoute(builder: (_) => DevMap());
      case '/dev':
        return MaterialPageRoute(builder: (_) => DevPage());
      case '/camera':
        return MaterialPageRoute(builder: (_) => CameraPage());
      default:
        return MaterialPageRoute(builder: (_) => MyApp());
    }
  }
}
