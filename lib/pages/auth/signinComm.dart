import 'package:ramo/models/user.dart';

import 'package:ramo/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ramo/services/databaseService.dart';

class SignInCommunityPage extends StatefulWidget {
  @override
  _SignInCommunityPagePageState createState() =>
      _SignInCommunityPagePageState();
}

class _SignInCommunityPagePageState extends State<SignInCommunityPage> {
  @override
  void initState() {
    super.initState();
    // DatabaseService().userData;
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context);
    // final user = context.watch<User>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(
                      10.0, screenData.size.height / 6.5, 0.0, 0.0),
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/img/logo2.png",
                        scale: screenData.size.height / 125,
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Container(
              padding: EdgeInsets.only(top: 5.0, left: 50.0, right: 50.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Ramo for Communities',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(
                            color: Color(0xFF009245),
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(
                            color: Color(0xFF82CAA4),
                            width: 2.0,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: Color(0xFF009245),
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: Color(0xFF82CAA4),
                          width: 2.0,
                        ),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.only(
                                left: 50, right: 50, top: 10, bottom: 10)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: Colors.green)))),
                    onPressed: () async {
                      dynamic result = await context.read<AuthService>().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                      if (result) {
                        // Navigator.of(context).pushNamed('/home');
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  InkWell(
                    child: Text(
                      "Register your community",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/signupcom');
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ]),
        ),
        bottomNavigationBar: Container(
          height: 50,
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ramo Beta',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ));
  }
}
