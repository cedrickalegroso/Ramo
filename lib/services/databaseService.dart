import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ramo/models/models.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import 'dart:developer';

import 'package:quiver/iterables.dart';

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

  Future<List<String>> getUserFollowing(uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('following')
        .get();

    final users = querySnapshot.docs.map((doc) => doc.id).toList();
    return users;
  }

  Stream<bool> isFollowing(uid, otherId) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("following")
        .doc(otherId)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Future<void> followUser(uid) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('following')
        .doc(uid)
        .set({});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({});
  }

  Future<void> unfollowUser(uid) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('following')
        .doc(uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .delete();
  }

  Stream<List<UserData>> getQueryNames(search) {
    return FirebaseFirestore.instance
        .collection('Users')
        .orderBy("name")
        .startAt([search])
        .endAt([search + '\uf8ff'])
        .limit(10)
        .snapshots()
        .map(_searchListFromSnapshop);
  }

  Stream<UserData> getUserInfo(uid) {
    print('Getting user info of $uid');
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .snapshots()
        .map(_userFromFirebaseSnapshot);
  }

  UserData _userFromFirebaseSnapshot(DocumentSnapshot snapshot) {
    return snapshot != null
        ? UserData(
            uid: snapshot.id,
            fname: snapshot.data()['fname'] ?? '',
            name: snapshot.data()['name'] ?? '',
            bio: snapshot.data()['bio'] ?? '',
            photoUrl: snapshot.data()['photoUrl'] ?? '',
            email: snapshot.data()['email'] ?? '',
          )
        : null;
  }

  List<UserData> _searchListFromSnapshop(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
          uid: doc.id,
          name: doc.data()['name'] ?? '',
          photoUrl: doc.data()['photoUrl'] ?? '');
    }).toList();
  }

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

  Future<List> getComms() async {
    print('taking comms');
    var query = userCollection.where('userType', isEqualTo: 1);

    return Future.value([1, 2, 3, 4]);
  }

  // POSTS

  List<Posts> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Posts(
        uid: doc.id,
        text: doc.data()['text'] ?? '',
        postType: doc.data()['postType'] ?? 0,
        fileUrl: doc.data()['fileUrl'] ?? '',
        creator: doc.data()['creator'] ?? '',
        timestamp: doc.data()['timestamp'] ?? 0,
      );
    }).toList();
  }

  Future savePost(text) async {
    print('savePost Called');
    await FirebaseFirestore.instance.collection("posts").add({
      'postType': 0,
      'text': text,
      'creator': FirebaseAuth.instance.currentUser.uid,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Future savePostWithImage(fileUrl, text) async {
    print('savePost with image Called');
    await FirebaseFirestore.instance.collection("posts").add({
      'postType': 1,
      'text': text,
      'fileUrl': fileUrl,
      'creator': FirebaseAuth.instance.currentUser.uid,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Stream<List<Posts>> getPostsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Future<List<Posts>> getFeed() async {
    List<String> usersFollowing =
        await getUserFollowing(FirebaseAuth.instance.currentUser.uid);

    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);
    inspect(splitUsersFollowing);

    List<Posts> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      inspect(splitUsersFollowing.elementAt(i));
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('creator', whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timestamp', descending: true)
          .get();

      feedList.addAll(_postListFromSnapshot(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timestamp;
      var bdate = b.timestamp;
      return bdate.compareTo(adate);
    });

    return feedList;
  }
}
