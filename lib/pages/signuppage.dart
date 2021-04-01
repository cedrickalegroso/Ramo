import 'package:ramo/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 0.0),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/img/logo2.png",
                    scale: 20.0,
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
                'Ramo Signup',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)))),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)))),
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
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
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
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.green)))),
                onPressed: () async {
                  bool result = await context.read<AuthService>().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      fullName: nameController.text.trim());
                  if (result) {
                    Navigator.of(context).pushNamed('/home');
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
                  Navigator.of(context).pushNamed('/signup');
                },
              )
            ],
          ),
        ),
      ]),
    );
  }
}
