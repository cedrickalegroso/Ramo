import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/misc/clipper.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/services/authService.dart';

class SettingsWrapper extends StatefulWidget {
  @override
  _SettingsWrapperState createState() => _SettingsWrapperState();
}

class _SettingsWrapperState extends State<SettingsWrapper> {
  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();
    final screenData = MediaQuery.of(context);
    return userData != null
        ? Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: GestureDetector(
                    child: Center(
                      child: ClipOval(
                          clipper: ProfileClipper(),
                          child: CachedNetworkImage(
                            imageUrl: userData.photoUrl,
                            width: screenData.size.height / 6,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )),
                    ),
                    onTap: () {},
                  ),
                ),
                SizedBox(
                  height: screenData.size.height / 40,
                ),
                Text('Jennie Kim',
                    style: TextStyle(
                        fontSize: screenData.size.height / 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: screenData.size.height / 20,
                ),
                Container(
                  width: screenData.size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFECECEC),
                  ),
                  child: Column(
                    children: [
                      Text('Jennie Kim',
                          style: TextStyle(
                              fontSize: screenData.size.height / 50,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      Text('Jennie Kim',
                          style: TextStyle(
                              fontSize: screenData.size.height / 50,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      Text('Jennie Kim',
                          style: TextStyle(
                              fontSize: screenData.size.height / 50,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      Text('Jennie Kim',
                          style: TextStyle(
                              fontSize: screenData.size.height / 50,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenData.size.height / 20,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                    width: screenData.size.width / 1.09,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.blueAccent)))),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/dev');
                      },
                      child: Text(
                        "DEV MODE",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                    width: screenData.size.width / 1.09,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: () {
                        context.read<AuthService>().signOut();
                      },
                      child: Text(
                        "Sign out",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                ])
              ],
            ),
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
