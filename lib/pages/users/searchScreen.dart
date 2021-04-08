import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/misc/clipper.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/services/authService.dart';

class SearchBarWrapper extends StatefulWidget {
  @override
  _SearchBarWrapperState createState() => _SearchBarWrapperState();
}

class _SearchBarWrapperState extends State<SearchBarWrapper> {
  String searchString;
  @override
  Widget build(BuildContext context) {
    body:
    Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value.toLowerCase();
                  });
                },
              ),
             ), 
            ),

              Expanded(
                   child: StreamBuilder<QuerySnapshot>(
                stream: 
                (searchString == null || searchString.trim() == "")
                ? FirebaseFirestore.instance.collection("Users").snapshots()
                : FirebaseFirestore.instance.collection("Users").where("SearchIndex")
                .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                     return Text('Error ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                     return Center(child: CircularProgressIndicator());
                    default: 
                    return new ListView(
                    //  children: snapshot.data.d
                        .map((DocumentSnapshot document) {
                             return ListTile(
                               title: Text(document['name']),
                             );
                        }),
                    );
                  }
                }
                ) ,
            ),
            
          
          ],
        )
      ],
    );
  }
}
