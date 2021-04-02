import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountSetup extends StatefulWidget {
  @override
  _AccountSetupState createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
              height: screenData.size.height,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Padding(
                            padding:
                                EdgeInsets.all(screenData.size.height / 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Let's get \nyou setup!",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: screenData.size.height / 10,
                                ),
                                TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
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
                                    controller: emailController,
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
                              ],
                            )),
                        Padding(
                            padding:
                                EdgeInsets.all(screenData.size.height / 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: screenData.size.height / 10,
                                ),
                                Text(
                                  'A community centric way of Recycling.',
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            )),
                        Padding(
                            padding:
                                EdgeInsets.all(screenData.size.height / 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: screenData.size.height / 10,
                                ),
                                Text(
                                  'A community centric way of Recycling.',
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ))
                      ],
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                    // _currentPage != _numPages - 1
                    //     ? Expanded(
                    //         child: Align(
                    //           alignment: FractionalOffset.bottomRight,
                    //           child: FlatButton(
                    //               onPressed: () {
                    //                 _pageController.nextPage(
                    //                     duration: Duration(milliseconds: 500),
                    //                     curve: Curves.ease);
                    //               },
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: <Widget>[
                    //                   Center(
                    //                       child: InkWell(
                    //                     child: Text(
                    //                       "Skip to Login",
                    //                       style: TextStyle(
                    //                           fontSize: 14.0,
                    //                           fontWeight: FontWeight.normal,
                    //                           color: Colors.white),
                    //                     ),
                    //                     onTap: () {
                    //                       Navigator.of(context)
                    //                           .pushNamed('/signin');
                    //                     },
                    //                   ))
                    //                 ],
                    //               )),
                    //         ),
                    //       )
                    //     : Text('')
                  ],
                ),
              ))),
      //   bottomSheet: _currentPage == _numPages - 1
      //       ? Container(
      //           height: 100.0,
      //           width: double.infinity,
      //           color: Colors.white,
      //           child: Center(
      //             child: GestureDetector(
      //                 onTap: () {
      //                   Navigator.of(context).pushNamed('/login');
      //                 },
      //                 child: Padding(
      //                     padding: EdgeInsets.only(bottom: 10.0),
      //                     child: Text(
      //                       'Get Started',
      //                       style: TextStyle(
      //                           color: Colors.blue,
      //                           fontSize: 35,
      //                           fontWeight: FontWeight.bold),
      //                     ))),
      //           ),
      //         )
      //       : Text(''),
    );
  }
}
