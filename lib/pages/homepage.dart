import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/pages/auth/accountsetup.dart';
import 'package:ramo/pages/dev/devhome.dart';
import 'package:ramo/pages/dev/objdtn.dart';
import 'package:ramo/services/authService.dart';
import 'package:ramo/pages/users/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ramo/pages/users/settings.dart';
import 'package:tflite/tflite.dart';
import 'dev/checkbox1.dart';

import 'package:ramo/pages/dev/cameraobjdtn.dart';
import 'package:ramo/pages/dev/boundingBox.dart';
import 'dart:math' as math;

const String mobile = "MobileNet";
const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";
const String deeplab = "DeepLab";
const String posenet = "PoseNet";

typedef void Callback(List<dynamic> list, int h, int w);

class HomePageStateful extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePageStateful(this.cameras);

  @override
  _HomePageStateful createState() => _HomePageStateful();
}

class _HomePageStateful extends State<HomePageStateful> {
  int _selectedIndex = 0;

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  loadModel() async {
    String result;

    switch (_model) {
      case ssd:
        result = await Tflite.loadModel(
            labels: "assets/objdtn/labels.txt",
            model: "assets/objdtn/ssd_mobilenet.tflite");
    }

    print(result);
  }

  onSelectModel(model) {
    setState(() {
      _model = model;
    });

    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  bool isCameraMode = false;

  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    DashboardWrapper(),
    CheckBoxListTileDemo(),
    SettingsWrapper(),
  ]; // to store nested tabs

  Widget currentScreen = DashboardWrapper(); // Our first view in viewport

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();
    final screenData = MediaQuery.of(context);
    Size screen = MediaQuery.of(context).size;
    return userData != null
        ? userData.hasDoneSetup == 1
            ? Scaffold(
                // appBar: AppBar(
                //   title: Text(
                //     '${userData.fname}',
                //     style: TextStyle(
                //         fontSize: 20.0,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black),
                //   ),
                //   backgroundColor: Colors.white,
                // ),
                body: Container(
                  height: screenData.size.height,
                  width: screenData.size.width,
                  child: isCameraMode == false
                      ? currentScreen
                      : _model == ""
                          ? Container()
                          : Stack(
                              children: [
                                CameraObjDtnState(
                                    widget.cameras, _model, setRecognitions),
                                BoundingBox(
                                    _recognitions == null ? [] : _recognitions,
                                    math.max(_imageHeight, _imageWidth),
                                    math.min(_imageHeight, _imageWidth),
                                    screen.width,
                                    screen.height,
                                    _model)
                              ],
                            ),

                  //       child: isCameraMode == 0 ? currentScreen
                  //       : _model == "" ? Container() :Stack(
                  //   children: [
                  //     CameraObjDtnState(widget.cameras, _model, setRecognitions),
                  //     BoundingBox(
                  //         _recognitions == null ? [] : _recognitions,
                  //         math.max(_imageHeight, _imageWidth),
                  //         math.min(_imageHeight, _imageWidth),
                  //         screen.width,
                  //         screen.height,
                  //         _model)
                  //   ],
                  // ),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.camera),
                  backgroundColor: Color(0xFF13A813),
                  onPressed: () {
                    isCameraMode == false
                        ? setState(() {
                            isCameraMode = true;
                            onSelectModel(ssd);
                          })
                        : setState(() {
                            isCameraMode = false;
                            onSelectModel('');
                          });
                  },
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  notchMargin: 10,
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0, 0, screenData.size.height / 7, 0),
                              child: MaterialButton(
                                minWidth: 40,
                                onPressed: () {
                                  setState(() {
                                    currentScreen =
                                        DashboardWrapper(); // if user taps on this dashboard tab will be active
                                    currentTab = 0;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: currentTab == 0
                                          ? Color(0xFF13A813)
                                          : Colors.grey,
                                    ),
                                    Text(
                                      'Dashboard',
                                      style: TextStyle(
                                        color: currentTab == 0
                                            ? Color(0xFF13A813)
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            MaterialButton(
                              minWidth: 50,
                              onPressed: () {
                                setState(() {
                                  currentScreen =
                                      SettingsWrapper(); // if user taps on this dashboard tab will be active
                                  currentTab = 1;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    color: currentTab == 1
                                        ? Color(0xFF13A813)
                                        : Colors.grey,
                                  ),
                                  Text(
                                    'Profile',
                                    style: TextStyle(
                                      color: currentTab == 1
                                          ? Color(0xFF13A813)
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            : AccountSetup()
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
