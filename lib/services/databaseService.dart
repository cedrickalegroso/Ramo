import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ramo/models/user.dart';
import 'package:ramo/models/userData.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<void> addUserToDatabase(String name, String email) async {
    return await userCollection
        .doc(uid)
        .set({'uid': uid, 'name': name, 'email': email})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> test(String test) async {
    return await userCollection.add({test: test});
  }

  UserData _getUserData(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'] ?? '',
      email: snapshot.data()['email'] ?? '',
    );
  }

  Stream<UserData> get userData {
    print('get used data 1');
    return userCollection.doc(uid).snapshots().map(_getUserData);
  }
}
