import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ramo/pages/auth/accountsetupComm.dart';
import 'package:ramo/pages/auth/signinComm.dart';
import 'package:ramo/pages/auth/signinpage.dart';
import 'package:ramo/pages/auth/signupComm.dart';
import 'package:ramo/pages/auth/signuppage.dart';
import 'package:ramo/pages/auth/accountsetup.dart';
import 'package:ramo/pages/auth/testmap.dart';
import 'package:ramo/main.dart';
import 'package:ramo/pages/dev/objdtn.dart';
import 'package:ramo/pages/homepage.dart';
import 'package:ramo/pages/homepagewrapper.dart';
import 'package:ramo/pages/onboarding/onboarding.dart';
import 'package:ramo/pages/dev/devhome.dart';
import 'package:ramo/pages/dev/camera.dart';
import 'package:ramo/pages/dev/checkbox1.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/signin':
        return MaterialPageRoute(builder: (_) => SignInPage());
      case '/signincom':
        return MaterialPageRoute(builder: (_) => SignInCommunityPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/signupcom':
        return MaterialPageRoute(builder: (_) => SignUpCommunityPage());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => Onboarding());
      case '/accsetup':
        return MaterialPageRoute(builder: (_) => AccountSetup());
      case '/accsetupcomm':
        return MaterialPageRoute(builder: (_) => AccountCommunitySetup());
      case '/devmap':
        return MaterialPageRoute(builder: (_) => DevMap());
      case '/dev':
        return MaterialPageRoute(builder: (_) => DevPage());
      case '/camera':
        return MaterialPageRoute(builder: (_) => CameraPage());
      case '/checkbox':
        return MaterialPageRoute(builder: (_) => CheckBoxListTileDemo());
      case '/homwrap':
        return MaterialPageRoute(builder: (_) => HomeWrapper());
      case '/objdtndev':
        return MaterialPageRoute(builder: (_) => ObjdtnState(cameras));
      default:
        return MaterialPageRoute(builder: (_) => MyApp());
    }
  }
}
