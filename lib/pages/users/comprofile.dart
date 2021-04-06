import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/services/databaseService.dart';
import 'package:ramo/models/models.dart';

class ProfileComm extends StatefulWidget {
  ProfileComm({
    Key key,
  }) : super(key: key);

  @override
  _ProfileCommState createState() => _ProfileCommState();
}

class _ProfileCommState extends State<ProfileComm> {
  DatabaseService _userService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context).settings.arguments;

    return MultiProvider(
        providers: [
          // StreamProvider.value(
          //   value: _userService.isFollowing(
          //       FirebaseAuth.instance.currentUser.uid, uid),
          // ),
          // StreamProvider.value(
          //   value: _postService.getPostsByUser(uid),
          // ),
          StreamProvider.value(
            value: _userService.getUserInfo(uid),
            initialData: null,
          )
        ],
        child: Scaffold(
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverAppBar(
                      floating: false,
                      pinned: true,
                      expandedHeight: 130,
                      flexibleSpace: FlexibleSpaceBar(
                          background: Image.network(
                        Provider.of<UserData>(context).photoUrl ?? '',
                        fit: BoxFit.cover,
                      )),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Provider.of<UserData>(context).photoUrl != ''
                                      ? CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              Provider.of<UserData>(context)
                                                  .photoUrl),
                                        )
                                      : Icon(Icons.person, size: 50),
                                  if (FirebaseAuth.instance.currentUser.uid ==
                                      uid)
                                    TextButton(
                                        onPressed: () {
                                          //  Navigator.pushNamed(context, '/edit');
                                        },
                                        child: Text("Edit ProfileComm"))
                                  // else if (FirebaseAuth
                                  //             .instance.currentUser.uid !=
                                  //         uid &&
                                  //     !Provider.of<bool>(context))
                                  //   TextButton(
                                  //       onPressed: () {
                                  //         //  _userService.followUser(uid);
                                  //       },
                                  //       child: Text("Follow"))
                                  // else if (FirebaseAuth
                                  //             .instance.currentUser.uid !=
                                  //         uid &&
                                  //     Provider.of<bool>(context))
                                  //   TextButton(
                                  //       onPressed: () {
                                  //         //   _userService.unfollowUser(uid);
                                  //       },
                                  //       child: Text("Unfollow")),
                                ]),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  Provider.of<UserData>(context).name ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  Provider.of<UserData>(context).bio ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ]))
                  ];
                },
                body: Text('FEEDS')),
          ),
        ));
  }
}
