import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ramo/main.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/pages/auth/accountsetup.dart';
import 'package:ramo/pages/auth/accountsetupComm.dart';
import 'package:ramo/pages/dev/devhome.dart';
import 'package:ramo/pages/dev/objdtn.dart';
import 'package:ramo/pages/homepage.dart';
import 'package:ramo/pages/homepagewrapper.dart';
import 'package:ramo/pages/homeppageCom.dart';
import 'package:ramo/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ramo/services/databaseService.dart';

class CheckPointStateful extends StatefulWidget {
  @override
  _CheckPointStateful createState() => _CheckPointStateful();
}

class _CheckPointStateful extends State<CheckPointStateful> {
  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();
    return userData != null
        ? userData.userType == 1
            ? HomePageComStateful()
            : HomePageStateful(cameras)
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
  }
}
