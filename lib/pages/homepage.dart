import 'package:ramo/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Home"),
        ElevatedButton(
          onPressed: () {
            context.read<AuthService>().signOut();
          },
          child: Text("Sign Out"),
        )
      ],
    )));
  }
}
