import 'package:flutter/material.dart';

class UserData {
  final String uid;
  final String email;
  final int hasGeo;
  final int hasDoneSetup;
  final String fname;
  // final String position;
  // final String prefs;
  final String lname;
  final String phone;
  final String photoUrl;

  UserData(
      {@required this.uid,
      this.email,
      this.hasGeo,
      this.hasDoneSetup,
      this.fname,
      this.lname,
      // this.prefs,
      // this.position,
      this.phone,
      this.photoUrl});
}
