import 'dart:async';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

// new Splashscreen
class _SplashscreenState extends State<Splashscreen> {
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5),
        () => Navigator.of(context).pushReplacementNamed('/signin'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [
              0.1,
              0.6,
            ],
                colors: [
              Color(0xFF13A813),
              Color(0xFF79DE86),
            ])),
      ),
      Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Image.asset(
                  "assets/img/logo.png",
                  scale: 20.0,
                ),
              ])),
        ),
        // Expanded(
        //     flex: 1,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         CircularProgressIndicator(
        //           backgroundColor: Colors.white,
        //         ),
        //         Padding(padding: EdgeInsets.only(bottom: 10.0)),
        //         Text(
        //           'Long waiting is a thing in the past',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 15.0,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         SizedBox(height: 10.0),
        //         Text(
        //           'Beta 1.0.5',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 15.0,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ))
      ])
    ]));
  }
}
