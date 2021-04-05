import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/models/userData.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

// class DatabaseService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final photoUrl = 'https://i.imgur.com/R8PduKR.png';

//   final CollectionReference userCollection =
//       FirebaseFirestore.instance.collection('Users');

//   Future<UserData> getUser(String id) async {
//     var snap = await _db.collection('Users').doc(id).get();
//     return UserData.fromMap(snap.data());
//   }

//   Future<void> addUserToDatabase(uid, email) async {
//     return await userCollection
//         .doc(uid)
//         .set({
//           'uid': uid,
//           'email': email,
//           'photoUrl': photoUrl,
//           'hasGeo': 0,
//           'hasDoneSetup': 0
//         })
//         .then((value) => print("User Added"))
//         .catchError((error) => print("Failed to add user: $error"));
//   }

//   Stream<UserData> streamUserData(String id) {
//     print('streaming $id');
//     return _db
//         .collection('Users')
//         .doc(id)
//         .snapshots()
//         .map((snap) => UserData.fromMap(snap.data()));
//   }
// }

class DatabaseService {
  Location location = new Location();
  GeoFlutterFire geo = GeoFlutterFire();
  final String uid;
//  var uid = FirebaseAuth.instance.currentUser.uid;
  DatabaseService({this.uid});
  final photoUrl = 'https://i.imgur.com/R8PduKR.png';

  Stream<UserData> get getdata =>
      userCollection.doc(uid).snapshots().map(_getUserData);

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference commCollection =
      FirebaseFirestore.instance.collection('Communities');

  Future<void> addUserToDatabase(uid, email) async {
    return await userCollection
        .doc(uid)
        .set({
          'uid': uid,
          'email': email,
          'userType': 0,
          'photoUrl': photoUrl,
          'hasGeo': 0,
          'hasDoneSetup': 0
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> updateUserData(fname, lname, phone, uid) async {
    try {
      await userCollection
          .doc(uid)
          .update({'fname': fname, 'lname': lname, 'phone': phone});
      return true;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> updateUserPref(prefs, uid) async {
    try {
      await userCollection.doc(uid).update({'prefs': prefs, 'hasDoneSetup': 1});
      return true;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> updateUserGeo(uid) async {
    try {
      var pos = await location.getLocation();
      GeoFirePoint pointFinal =
          geo.point(latitude: pos.latitude, longitude: pos.longitude);
      await userCollection
          .doc(uid)
          .update({'position': pointFinal.data, 'hasGeo': 1});
      return true;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> updatePorfilePicture(a, b) async {
    return await userCollection
        .doc(b)
        .update({'photoUrl': a})
        .then((value) => print("Profile Updated"))
        .catchError((error) => print("Failed to update profile: $error"));
  }

  Future<void> callData() async {
    print('calling userdata');
    return userData;
  }

  UserData _getUserData(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'] ?? '',
      fname: snapshot.data()['fname'] ?? '',
      lname: snapshot.data()['lname'] ?? '',
      phone: snapshot.data()['phone'] ?? '',
      email: snapshot.data()['email'] ?? '',
      hasDoneSetup: snapshot.data()['hasDoneSetup'] ?? '',
      userType: snapshot.data()['userType'] ?? '',
      // position: snapshot.data()['position'] ?? '',
      // prefs: snapshot.data()['prefs'] ?? '',
      hasGeo: snapshot.data()['hasGeo'] ?? '',
      photoUrl: snapshot.data()['photoUrl'] ?? '',
    );
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_getUserData);
  }

  // COMMUNITY SPECIFIC METHODS

  Future<void> addCommunityToDatabase(uid, email) async {
    return await userCollection
        .doc(uid)
        .set({
          'uid': uid,
          'email': email,
          'userType': 1,
          'photoUrl': photoUrl,
          'hasGeo': 0,
          'hasDoneSetup': 0
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> updateCommunityData(_name, _bio, phone, uid) async {
    try {
      await userCollection
          .doc(uid)
          .update({'name': _name, 'bio': _bio, 'phone': phone});
      return true;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> updateCommunityGeo(uid) async {
    try {
      var pos = await location.getLocation();
      GeoFirePoint pointFinal =
          geo.point(latitude: pos.latitude, longitude: pos.longitude);
      await commCollection
          .doc(uid)
          .update({'position': pointFinal.data, 'hasGeo': 1});
      return true;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> updateCommunityPorfilePicture(a, b) async {
    return await userCollection
        .doc(b)
        .update({'photoUrl': a})
        .then((value) => print("Profile Updated"))
        .catchError((error) => print("Failed to update profile: $error"));
  }
}
