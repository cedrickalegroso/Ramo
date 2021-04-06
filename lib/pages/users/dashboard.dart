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

class DashboardWrapper extends StatefulWidget {
  @override
  _DashboardWrapperState createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  DatabaseService _databaseService = DatabaseService();
  String search = 's';

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context) ?? [];
    final userData = context.watch<UserData>();
    final screenData = MediaQuery.of(context);
    var firebaseuser;
    return userData != null
        ? Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  0.0, screenData.size.height / 10, 0.0, 0.0),
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1.5, color: Colors.grey[300]),
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              child: GestureDetector(
                                child: Center(
                                  child: ClipOval(
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
                                ),
                                onTap: () {},
                              ),
                            ),
                            SizedBox(
                              width: screenData.size.height / 29,
                            ),
                            Text('Jennie Kim',
                                style: TextStyle(
                                    fontSize: screenData.size.height / 50,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(width: screenData.size.height / 4.5),
                            IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/search');
                                })
                          ],
                        ),
                      )),
                  // SingleChildScrollView(
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         height: screenData.size.height / 5,
                  //         width: screenData.size.width,
                  //         color: Colors.greenAccent,
                  //       ),
                  //       SizedBox(
                  //         height: screenData.size.height / 10,
                  //       ),
                  //       Container(
                  //         height: screenData.size.height / 5,
                  //         width: screenData.size.width,
                  //         color: Colors.greenAccent,
                  //       ),
                  //       SizedBox(
                  //         height: screenData.size.height / 10,
                  //       ),
                  //       Container(
                  //         height: screenData.size.height / 5,
                  //         width: screenData.size.width,
                  //         color: Colors.greenAccent,
                  //       ),
                  //       SizedBox(
                  //         height: screenData.size.height / 10,
                  //       ),
                  //       Container(
                  //         height: screenData.size.height / 5,
                  //         width: screenData.size.width,
                  //         color: Colors.greenAccent,
                  //       ),
                  //       SizedBox(
                  //         height: screenData.size.height / 10,
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          )
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

class DataSearch extends SearchDelegate<String> {
  final cities = [
    'Manila',
    'Metro Pasig',
    'BGC',
    'Iloilo',
    'Cebu',
    'Bacolod',
    'Pasay',
    'Pasig',
  ];

  final recentSearch = [
    'Iloilo',
    'Cebu',
    'Bacolod',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show results based ib selection
    return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches

    final suggestionList = query.isEmpty ? recentSearch : cities;
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.local_atm),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
