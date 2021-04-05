import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/pages/auth/accountsetup.dart';
import 'package:ramo/pages/auth/accountsetupComm.dart';
import 'package:ramo/pages/dev/devhome.dart';
import 'package:ramo/pages/dev/objdtn.dart';
import 'package:ramo/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ramo/services/databaseService.dart';

class HomePageComStateful extends StatefulWidget {
  @override
  _HomePageComStateful createState() => _HomePageComStateful();
}

class _HomePageComStateful extends State<HomePageComStateful> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: OBJ DETECTION',
      style: optionStyle,
    ),
    Text(
      'Index 2: Settings',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();
    return userData != null
        ? userData.hasDoneSetup == 1
            ? Scaffold(
                appBar: AppBar(
                  title: Text(
                    '${userData.name}',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                ),
                body: Center(
                  child: Column(children: [
                    Text('Community'),
                    InkWell(
                      child: Text(
                        "DEVELOPER MODE",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/dev');
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthService>().signOut();
                      },
                      child: Text("Sign Out"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Sign wew"),
                    ),
                    _widgetOptions.elementAt(_selectedIndex)
                  ]),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business),
                      label: 'Business',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business),
                      label: 'Business',
                    )
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.amber[800],
                  onTap: _onItemTapped,
                ),
              )
            : AccountCommunitySetup()
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
