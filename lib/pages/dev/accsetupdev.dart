import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/models/userData.dart';
import 'package:ramo/services/authService.dart';
import 'package:ramo/models/User.dart';
import 'package:provider/provider.dart';
import 'package:ramo/misc/clipper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:ramo/services/databaseService.dart';
import 'package:ramo/misc/loading.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';

class AccountSetup extends StatefulWidget {
  @override
  _AccountSetupState createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  List<CheckBoxListTileModel> checkBoxListTileModel =
      CheckBoxListTileModel.getUsers();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5),
        () => Navigator.of(context).pushReplacementNamed('/signin'));
  }

  final _imagePicker = ImagePicker();
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List prefs = List.empty(growable: true);

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  int checkedcounter = 0;

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 16.0 : 16.0,
      decoration: BoxDecoration(
          color: isActive ? Color(0xFF009245) : Color(0xFFDDEEDD),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();

    final screenData = MediaQuery.of(context);

    _newProfilePicture() async {
      final image = await _imagePicker.getImage(source: ImageSource.camera);

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profiles')
          .child('/${userData.uid}.png');

      firebase_storage.UploadTask uploadTask;
      uploadTask = ref.putFile(File(image.path));
      await uploadTask;
      ref.getDownloadURL().then((fileUrl) {
        DatabaseService().updatePorfilePicture(fileUrl, userData.uid);
      });
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
                height: screenData.size.height,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          Padding(
                              padding:
                                  EdgeInsets.all(screenData.size.height / 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: screenData.size.height / 50,
                                  ),
                                  Text(
                                    "Account Setup",
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Hi! Tell us something about yourself.",
                                    style: TextStyle(
                                        fontSize: screenData.size.height / 50,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    child: Center(
                                      child: ClipOval(
                                          clipper: ProfileClipper(),
                                          child: CachedNetworkImage(
                                            imageUrl: userData.photoUrl,
                                            width: screenData.size.height / 6,
                                            placeholder: (context, url) =>
                                                Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )),
                                    ),
                                    onTap: _newProfilePicture,
                                  ),
                                  SizedBox(
                                    height: screenData.size.height / 50,
                                  ),
                                  TextField(
                                      controller: firstname,
                                      decoration: InputDecoration(
                                        labelText: 'Your Firstname',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                            color: Color(0xFF009245),
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                            color: Color(0xFF82CAA4),
                                            width: 2.0,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: screenData.size.height / 50,
                                  ),
                                  TextField(
                                      controller: lastname,
                                      decoration: InputDecoration(
                                        labelText: 'Your Lastname',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                            color: Color(0xFF009245),
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                            color: Color(0xFF82CAA4),
                                            width: 2.0,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: screenData.size.height / 50,
                                  ),
                                  TextField(
                                      controller: phoneNumber,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                            color: Color(0xFF009245),
                                            width: 2.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          borderSide: BorderSide(
                                            color: Color(0xFF82CAA4),
                                            width: 2.0,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: screenData.size.height / 40,
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                        padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.only(
                                                    left: 100,
                                                    right: 100,
                                                    top: 15,
                                                    bottom: 15)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                side: BorderSide(color: Colors.green)))),
                                    onPressed: () async {
                                      final uid = userData.uid;
                                      final lname = lastname.text.trim();
                                      final fname = firstname.text.trim();
                                      final phone = phoneNumber.text.trim();
                                      bool result = await context
                                          .read<DatabaseService>()
                                          .updateUserData(
                                              fname, lname, phone, uid);
                                      if (result) {
                                        _pageController.nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      }
                                    },
                                    child: Text(
                                      "Next Step",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.all(screenData.size.height / 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: screenData.size.height / 50,
                                  ),
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Center(
                                    child: Text(
                                      "We need to know where you are located to serve you better! If for some reason you don't enable this feature you can use Ramo but in limited features only.",
                                      style: TextStyle(
                                          fontSize: screenData.size.height / 50,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                        padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.only(
                                                    left: 100,
                                                    right: 100,
                                                    top: 15,
                                                    bottom: 15)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                side: BorderSide(color: Colors.green)))),
                                    onPressed: () async {
                                      final uid = userData.uid;
                                      bool result = await context
                                          .read<DatabaseService>()
                                          .updateUserGeo(uid);
                                      if (result) {
                                        _pageController.nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      }

                                      // _pageController.nextPage(
                                      //     duration: Duration(milliseconds: 500),
                                      //     curve: Curves.ease);
                                    },
                                    child: Text(
                                      "Next Step",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.all(screenData.size.height / 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: screenData.size.height / 50,
                                  ),
                                  Text(
                                    "Communities",
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenData.size.height / 100,
                                  ),
                                  Text(
                                    "Here are some communities that you might want to follow",
                                    style: TextStyle(
                                        fontSize: screenData.size.height / 50,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: checkBoxListTileModel.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return new Card(
                                          child: new Container(
                                            padding: new EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                new CheckboxListTile(
                                                    activeColor:
                                                        Colors.pink[300],
                                                    dense: true,
                                                    //font change
                                                    title: new Text(
                                                      checkBoxListTileModel[
                                                              index]
                                                          .title,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.5),
                                                    ),
                                                    value:
                                                        checkBoxListTileModel[
                                                                index]
                                                            .isCheck,
                                                    secondary: Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: Image.asset(
                                                        checkBoxListTileModel[
                                                                index]
                                                            .img,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    onChanged: (bool val) {
                                                      itemChange(val, index);
                                                    })
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  SizedBox(
                                    height: screenData.size.height / 50,
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                        padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.only(
                                                    left: 100,
                                                    right: 100,
                                                    top: 15,
                                                    bottom: 15)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                side: BorderSide(color: Colors.green)))),
                                    onPressed: () async {
                                      final uid = userData.uid;
                                      bool result = await context
                                          .read<DatabaseService>()
                                          .updateUserPref(prefs, uid);
                                      if (result) {
                                        Navigator.of(context)
                                            .pushNamed('/home');
                                      }
                                    },
                                    child: Text(
                                      "Next Step",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                    ],
                  ),
                ))));
  }

  void itemChange(bool val, int index) {
    setState(() {
      checkBoxListTileModel[index].isCheck = val;
      prefs.add(checkBoxListTileModel[index].title);
    });
  }
}

class CheckBoxListTileModel {
  int userId;
  String img;
  String title;
  bool show;
  bool isCheck;

  CheckBoxListTileModel(
      {this.userId, this.img, this.title, this.show, this.isCheck});

  static List<CheckBoxListTileModel> getUsers() {
    return <CheckBoxListTileModel>[
      CheckBoxListTileModel(
          userId: 1,
          show: true,
          img: 'assets/images/android_img.png',
          title: "Pastics",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 2,
          show: true,
          img: 'assets/images/flutter.jpeg',
          title: "Bottles",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 3,
          show: true,
          img: 'assets/images/ios_img.webp',
          title: "Charities",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 4,
          show: true,
          img: 'assets/images/php_img.png',
          title: "Foods",
          isCheck: false),
      CheckBoxListTileModel(
          userId: 5,
          show: true,
          img: 'assets/images/node_img.png',
          title: "Others",
          isCheck: false),
    ];
  }
}
