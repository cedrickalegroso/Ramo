import 'package:ramo/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DevPage extends StatefulWidget {
  const DevPage({
    Key key,
  }) : super(key: key);

  @override
  _DevPageStateful createState() => _DevPageStateful();
}

class _DevPageStateful extends State<DevPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DEV TESTING MODE',
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              child: Text(
                "DEV MAP",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.red),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/devmap');
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              child: Text(
                "onboarding",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.red),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/onboarding');
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              child: Text(
                "Account Setup",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.red),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/accsetup');
              },
            ),
          ],
        ),
      ),
    );
  }
}
