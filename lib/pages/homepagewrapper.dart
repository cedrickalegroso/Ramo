import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/pages/auth/checkpoint.dart';
import 'package:ramo/pages/homepage.dart';
import 'package:ramo/services/databaseService.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  DatabaseService _databaseService = DatabaseService();
  String search = '';
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();
    return firebaseuser != null
        ? MultiProvider(
            providers: [
              Provider<DatabaseService>(
                  create: (_) => DatabaseService(uid: firebaseuser.uid)),
              StreamProvider<UserData>.value(
                value: DatabaseService(uid: firebaseuser.uid).userData,
                initialData: null,
              ),
              StreamProvider.value(
                value: _databaseService.getQueryNames(search),
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
