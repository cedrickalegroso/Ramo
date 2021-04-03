import 'package:ramo/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ramo/services/databaseService.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Stream<UserData> get user {
    return _auth.authStateChanges().map(
          (User firebaseUser) =>
              (firebaseUser != null) ? UserData(uid: firebaseUser.uid) : null,
        );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print('userfound');
      return true; // not the best way AHHAHA
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //update later with message pop ups or kung ano man da
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  Future<bool> signUp({String email, String password}) async {
    print('here naa');
    // try {
    //   await _firebaseAuth.createUserWithEmailAndPassword(
    //       email: email, password: password);
    // } catch (e) {
    //   return e.message;
    // }
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('user signed up successfully');
      var uid = FirebaseAuth.instance.currentUser.uid;
      DatabaseService().addUserToDatabase(uid, email);

      // addUser(email: email, fullName: fullName);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    }
  }

  // Future<void> addUser({String email, String fullName}) async {
  //   CollectionReference users = FirebaseFirestore.instance.collection('Users');
  //   String uid = FirebaseAuth.instance.currentUser.uid;
  //   users
  //       .doc(uid)
  //       .set({
  //         'full name': fullName,
  //         'email': email,
  //         'uid': uid,
  //       })
  //       .then((value) => print("User Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }
}
