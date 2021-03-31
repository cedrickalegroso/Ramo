import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

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

  Future<bool> signUp({String email, String password, String fullName}) async {
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
      addUser(email: email, fullName: fullName);
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

  Future<void> addUser({String email, String fullName}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    String uid = FirebaseAuth.instance.currentUser.uid;
    users
        .add({
          'full name:': fullName,
          'email': email,
          'uid': uid,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
