import 'package:flutter/material.dart';

class UserData {
  const UserData({
    @required this.uid,
    this.email,
    this.name,
  });

  final String uid;
  final String email;
  final String name;
}
