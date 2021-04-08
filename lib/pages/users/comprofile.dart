import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/misc/clipper.dart';
import 'package:ramo/services/authService.dart';
import 'package:ramo/services/databaseService.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/pages/users/postList.dart';

class ProfileComm extends StatefulWidget {
  ProfileComm({
    Key key,
  }) : super(key: key);

  @override
  _ProfileCommState createState() => _ProfileCommState();
}

class _ProfileCommState extends State<ProfileComm> {
  // DatabaseService _userService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context).settings.arguments;
    final screenData = MediaQuery.of(context);
    final _userService = context.read<DatabaseService>();
    final firebaseuser = context.watch<User>();
    final commData = context.watch<UserData>();
    return MultiProvider(
        providers: [
          StreamProvider.value(
            value: _userService.isFollowing(firebaseuser.uid, uid),
            initialData: false,
          ),
          StreamProvider.value(
            value: _userService.getPostsByUser(uid),
            initialData: null,
          ),
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
                      snap: false,
                      expandedHeight: 160.0,
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                          title: Title(
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: screenData.size.height / 10),
                                child: Row(
                                  children: [
                                    ClipOval(
                                        clipper: ProfileClipper(),
                                        child: CachedNetworkImage(
                                          imageUrl: commData.photoUrl,
                                          width: screenData.size.height / 20,
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )),
                                    SizedBox(
                                      width: screenData.size.width / 70,
                                    ),
                                    Text(
                                      commData.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              screenData.size.height / 60),
                                    ),
                                    //                                   Align(
                                    //   alignment: Alignment.centerLeft,
                                    //   child: Container(
                                    //     padding: EdgeInsets.symmetric(vertical: 5),
                                    //     child: Text(
                                    //       Provider.of<UserData>(context).bio ?? '',
                                    //       style: TextStyle(
                                    //         fontWeight: FontWeight.normal,
                                    //         fontSize: 14,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )),
                          background: Image.network(
                            commData.photoUrl ?? '',
                            fit: BoxFit.cover,
                          )),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (FirebaseAuth.instance.currentUser.uid ==
                                      uid)
                                    TextButton(
                                        onPressed: () {
                                          //  Navigator.pushNamed(context, '/edit');
                                        },
                                        child: Text("Edit ProfileComm"))
                                  else if (FirebaseAuth
                                              .instance.currentUser.uid !=
                                          uid &&
                                      !Provider.of<bool>(context))
                                    TextButton(
                                        onPressed: () {
                                          _userService.followUser(uid);
                                        },
                                        child: Text("Follow"))
                                  else if (FirebaseAuth
                                              .instance.currentUser.uid !=
                                          uid &&
                                      Provider.of<bool>(context))
                                    TextButton(
                                        onPressed: () {
                                          _userService.unfollowUser(uid);
                                        },
                                        child: Text("Unfollow")),
                                ]),
                          ],
                        ),
                      )
                    ]))
                  ];
                },
                body: ListPosts()),
          ),
        ));
  }
}
