import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/pages/auth/accountsetup.dart';
import 'package:ramo/pages/auth/signinpage.dart';
import 'package:ramo/pages/auth/signuppage.dart';
import 'package:ramo/pages/homepagewrapper.dart';
import 'package:ramo/services/authService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ramo/services/databaseService.dart';
import 'package:ramo/services/routerService.dart';
import 'package:ramo/pages/homepage.dart';
import 'package:ramo/models/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramo/pages/onboarding/onboarding.dart';
import 'package:ramo/models/user.dart' as _user;

import 'models/models.dart';

List<CameraDescription> cameras;

int onBoardScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  onBoardScreen = await _prefs.getInt('onBoardScreen');
  await _prefs.setInt('onBoardScreen', 1);
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('CAMERA FAIL ERROR CODE: $e'); // prints camera errors
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        // Provider<DatabaseService>(create: (_) => DatabaseService()),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        // FirebaseAuth.instance.currentUser != null
        //     ? StreamProvider<UserData>.value(
        //         value:
        //             DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
        //                 .userData,
        //         initialData: null,
        //       )
        //     : StreamProvider<UserData>.value(
        //         value: DatabaseService().userData,
        //         initialData: null,
        //       )
      ],
      child: MaterialApp(
          onGenerateRoute: RouteGenerator.generateRoute,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            body: Container(
              child: onBoardScreen == 1
                  ? AuthenticationWrapperState()
                  : Onboarding(),
            ),
          )
          // initialRoute:
          //     onBoardScreen == 0 || onBoardScreen == null ? 'Onboarding' : 'home',
          // routes: {
          //   'Onboarding': (context) => Onboarding(),
          //   'home': (context) => AuthenticationWrapper()
          // },
          ),
    );
  }
}

class AuthenticationWrapperState extends StatefulWidget {
  final List<CameraDescription> cameras;
  const AuthenticationWrapperState({Key key, this.cameras}) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapperState> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: context.read<AuthService>().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        }
        final firebaseuser = snapshot.data;
        if (firebaseuser == null) {
          print('No user is logged in');
          return SignInPage();
        } else {
          print(
              'User with uid: ${firebaseuser.uid}, email: ${firebaseuser.email} is logged in');
          return HomeWrapper();
        }
      },
    );
    // final userData = context.watch<UserData>();
    // if (firebaseuser != null) {
    //   userData == null
    //       ? setState(() {
    //           loading = false;
    //         })
    //       : setState(() {
    //           loading = true;
    //           print('DEBUG ${userData.hasDoneSetup}');
    //         });
    // } else {
    //   return SignInPage();
    // }
    // return loading
    //     ? userData.hasDoneSetup == 1
    //         ? HomePageStateful()
    //         : AccountSetup()
    //     : Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Center(
    //             child: CircularProgressIndicator(),
    //           )
    //         ],
    //       );

//  firebaseuser != null
//         ? SignInPage()
//         : userData == null
//             ? setState(() {
//                 loading = false;

//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   ],
//                 );
//               })
//             : setState(() {
//                 loading = true;

//                 userData.hasDoneSetup == 1
//                     ? HomePageStateful()
//                     : AccountSetup();
//               });

    //   userData == null
    //       ? setState(() {
    //           loading = true;
    //         })
    //       : setState(() {
    //           loading = false;
    //         });

    //   return loading
    //       ? userData.hasDoneSetup == 1
    //           ? HomePageStateful()
    //           : AccountSetup()
    //       : Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           ],
    //         );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         StreamProvider<User>.value(
//             value: FirebaseAuth.instance.authStateChanges(), initialData: null)
//       ],
//       child: MaterialApp(
//         // theme: ThemeData(brightness: Brightness.dark),
//         onGenerateRoute: RouteGenerator.generateRoute,
//         home: Scaffold(
//           body: Container(
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   colors: [Colors.deepOrange, Colors.orange[600]],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight),
//             ),
//             child: Center(
//               child: new Root(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Root extends StatelessWidget {
//   final auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     var user = Provider.of<User>(context);
//     bool loggedIn = user != null;

//     if (loggedIn) {
//       HeroScreen();
//     } else {
//       SignUpPage();
//     }
//   }
// }

// class HeroScreen extends StatelessWidget {
//   final auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     var user = Provider.of<User>(context);
//     bool loggedIn = user != null;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         if (loggedIn) ...[
//           TextButton(onPressed: auth.signOut, child: Text('Log out')),
//           StreamBuilder<UserData>(
//             stream: DatabaseService().streamUserData(user.uid),
//             builder: (context, snapshot) {
//               var hero = snapshot.data;
//               print(user.uid);
//               print(hero);
//               if (hero != null) {
//                 print('not null');
//                 return Column(
//                   children: <Widget>[
//                     Text('Equip ${hero.email}',
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.headline),
//                   ],
//                 );
//               } else {
//                 return RaisedButton(
//                     child: Text('Create'), onPressed: () => print('tap'));
//               }
//             },
//           ),
//         ],
//         if (!loggedIn) ...[
//           TextButton(onPressed: auth.signInAnonymously, child: Text('Log in')),
//           InkWell(
//             child: Text('sign in'),
//             onTap: () {
//               Navigator.of(context).pushReplacementNamed('/signup');
//             },
//           )
//         ]
//       ],
//     );
//   }
// }

// class RootWidget extends StatelessWidget {
//   const RootWidget({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final firebaseuser = context.watch<User>();
//     if (firebaseuser != null) {
//       print('usefound');
//       // final userData = context.watch<UserData>();
//       // return userData.hasDoneSetup == 1 ? HomePageStateful() : AccountSetup();
//     } else {
//       return SignInPage();
//     }
//   }
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<AuthService>(
//           create: (_) => AuthService(FirebaseAuth.instance),
//         ),
//         Provider<DatabaseService>(
//             create: (_) =>
//                 DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)),
//         StreamProvider(
//           create: (context) => context.read<AuthService>().authStateChanges,
//           initialData: null,
//         ),
//         FirebaseAuth.instance.currentUser != null
//             ? StreamProvider<UserData>.value(
//                 value:
//                     DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
//                         .userData,
//                 initialData: null,
//               )
//             : StreamProvider<UserData>.value(
//                 value: DatabaseService().userData,
//                 initialData: null,
//               )
//       ],
//       child: MaterialApp(
//         onGenerateRoute: RouteGenerator.generateRoute,
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: AuthenticationWrapper(),
//         // initialRoute:
//         //     onBoardScreen == 0 || onBoardScreen == null ? 'Onboarding' : 'home',
//         // routes: {
//         //   'Onboarding': (context) => Onboarding(),
//         //   'home': (context) => AuthenticationWrapper()
//         // },
//       ),
//     );
//   }
// }

// class AuthenticationWrapper extends StatelessWidget {
//   const AuthenticationWrapper({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final firebaseuser = context.watch<User>();
//     if (firebaseuser != null) {
//       final userData = context.watch<UserData>();
//       return userData.hasDoneSetup == 1 ? HomePageStateful() : AccountSetup();
//     } else {
//       return SignInPage();
//     }
//   }
// }
