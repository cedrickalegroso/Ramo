import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/misc/clipper.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/services/authService.dart';
import 'package:ramo/services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ramo/pages/users/postList.dart';

class DashboardWrapper extends StatefulWidget {
  @override
  _DashboardWrapperState createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  DatabaseService _postService = DatabaseService();
  String search = '';

  @override //
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();
    final screenData = MediaQuery.of(context);
    return userData != null
        ? FutureProvider.value(
            value: _postService.getFeed(),
            initialData: null,
            child: Scaffold(
                body: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        snap: true,
                        expandedHeight: 10,
                        backgroundColor: Colors.white,
                        title: Title(
                            color: Colors.red,
                            child: Row(
                              children: [
                                SizedBox(width: screenData.size.height / 50),
                                ClipOval(
                                    clipper: ProfileClipper(),
                                    child: CachedNetworkImage(
                                      imageUrl: userData.photoUrl,
                                      width: screenData.size.height / 20,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )),
                                SizedBox(
                                  width: screenData.size.width / 50,
                                ),
                                Text(
                                  userData.fname,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenData.size.height / 60),
                                ),
                                SizedBox(width: screenData.size.height / 3.6),
                                IconButton(
                                    icon: Icon(Icons.search),
                                    color: Colors.black,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/search');
                                    })
                              ],
                            )),
                      ),
                    ];
                  },
                  body: ListPosts()),
            )))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
  }
}

// Container(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                     0.0, screenData.size.height / 10, 0.0, 0.0),
//                 child: Column(
//                   children: [
//                     Container(
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom:
//                                 BorderSide(width: 1.5, color: Colors.grey[300]),
//                           ),
//                         ),
//                         child: Padding(
//                           padding:
//                               EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                           child: Row(
//                             children: [
//                               Container(
//                                 child: GestureDetector(
//                                   child: Center(
//                                     child: ClipOval(
//                                         clipper: ProfileClipper(),
//                                         child: CachedNetworkImage(
//                                           imageUrl: userData.photoUrl,
//                                           width: screenData.size.height / 20,
//                                           placeholder: (context, url) => Center(
//                                             child: CircularProgressIndicator(),
//                                           ),
//                                           errorWidget: (context, url, error) =>
//                                               Icon(Icons.error),
//                                         )),
//                                   ),
//                                   onTap: () {},
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: screenData.size.height / 29,
//                               ),
//                               Text('Jennie Kim',
//                                   style: TextStyle(
//                                       fontSize: screenData.size.height / 50,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.normal)),
//                               SizedBox(width: screenData.size.height / 4.5),
//                               IconButton(
//                                   icon: Icon(Icons.search),
//                                   onPressed: () {
//                                     Navigator.of(context).pushNamed('/search');
//                                   })
//                             ],
//                           ),
//                         )),

//                   ],
//                 ),
//               ),
//             ),
