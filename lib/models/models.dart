import 'package:flutter/material.dart';

class UserData {
  final String uid;
  final String email;
  final int hasGeo;
  final int hasDoneSetup;
  final int userType;
  final String fname;
  final String name;
  final String bio;
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
      this.userType,
      this.fname,
      this.lname,
      this.name,
      this.bio,
      // this.prefs,
      // this.position,
      this.phone,
      this.photoUrl});
}

class UserModel {
  final String uid;
  final String email;
  final int hasGeo;
  final int hasDoneSetup;
  final int userType;
  final String fname;
  final String name;
  final String bio;
  // final String position;
  // final String prefs;
  final String lname;
  final String phone;
  final String photoUrl;

  UserModel(
      {@required this.uid,
      this.email,
      this.hasGeo,
      this.hasDoneSetup,
      this.userType,
      this.fname,
      this.lname,
      this.name,
      this.bio,
      // this.prefs,
      // this.position,
      this.phone,
      this.photoUrl});
}

class CommunityData {
  final String uid;
  final String email;
  final int hasGeo;
  final int hasDoneSetup;
  final int userType;
  final String name;
  final String bio;
  final String phone;
  final String photoUrl;

  CommunityData(
      {@required this.uid,
      this.email,
      this.hasGeo,
      this.hasDoneSetup,
      this.userType,
      this.name,
      this.bio,
      this.phone,
      this.photoUrl});
}
