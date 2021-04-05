import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/pages/homepage.dart';
import 'package:ramo/services/databaseService.dart';

import 'auth/checkpoint.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();

    print(firebaseuser);

    return firebaseuser != null
        ? MultiProvider(
            providers: [
              Provider<DatabaseService>(
                  create: (_) => DatabaseService(uid: firebaseuser.uid)),
              StreamProvider<UserData>.value(
                value: DatabaseService(uid: firebaseuser.uid).userData,
                initialData: null,
              )
            ],
            child: CheckPointStateful(),
          )
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
