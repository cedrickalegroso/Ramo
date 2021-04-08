import 'package:flutter/material.dart';

class Communities {
  const Communities({
    @required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
}
