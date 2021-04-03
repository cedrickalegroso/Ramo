import 'package:ramo/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ramo/services/databaseService.dart';
import 'dart:async';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
    //  DatabaseService().userData;
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 1.0, left: 50.0, right: 50.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Ramo sign up',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: screenData.size.height / 20,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF82CAA4),
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
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF009245)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.green)))),
                      onPressed: () async {
                        bool result = await context.read<AuthService>().signUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                        if (result) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        "Create Account",
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
                        "Ramo for communities",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/home');
                      },
                    )
                  ],
                ),
              ),
            ]),
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
