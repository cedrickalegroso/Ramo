import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/pages/dev/searchlist.dart';
import 'package:ramo/services/databaseService.dart';

class TESTSEARCHPage extends StatefulWidget {
  @override
  _TESTSEARCHPageState createState() => new _TESTSEARCHPageState();
}

class _TESTSEARCHPageState extends State<TESTSEARCHPage> {
  DatabaseService _databaseService = DatabaseService();
  String search = '';

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context);
    return Scaffold(
      body: MultiProvider(
        providers: [
          StreamProvider.value(
            value: _databaseService.getQueryNames(search),
            initialData: null,
          )
        ],
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenData.size.height / 10),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    search = text;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        print('tapped');
                        Navigator.of(context).pop();
                      }),
                ),
              ),
            ),
            ListUsers()
          ],
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class CloudFirestoreSearch extends StatefulWidget {
//   @override
//   _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
// }

// class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
//   String name = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Card(
//           child: TextField(
//             decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search), hintText: 'Search...'),
//             onChanged: (val) {
//               setState(() {
//                 name = val;
//               });
//             },
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: (name != "" && name != null)
//             ? FirebaseFirestore.instance
//                 .collection('Users')
//                 .where("userType", isEqualTo: 1)
//                 .where("name", arrayContains: name)
//                 .snapshots()
//             : FirebaseFirestore.instance.collection("Users").snapshots(),
//         builder: (context, snapshot) {
//           return (snapshot.connectionState == ConnectionState.waiting)
//               ? Center(child: CircularProgressIndicator())
//               : ListView.builder(
//                   itemCount: snapshot.data.documents.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot data = snapshot.data.documents[index];
//                     return Card(
//                       child: Row(
//                         children: <Widget>[
//                           Image.network(
//                             data['imageUrl'],
//                             width: 150,
//                             height: 100,
//                             fit: BoxFit.fill,
//                           ),
//                           SizedBox(
//                             width: 25,
//                           ),
//                           Text(
//                             data['name'],
//                             style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontSize: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//         },
//       ),
//     );
//   }
// }

// class DataSearch extends SearchDelegate<String> {
//   final cities = [
//     'Manila',
//     'Metro Pasig',
//     'BGC',
//     'Iloilo',
//     'Cebu',
//     'Bacolod',
//     'Pasay',
//     'Pasig',
//   ];

//   final recentSearch = [
//     'Iloilo',
//     'Cebu',
//     'Bacolod',
//   ];

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             query = "";
//           })
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     // leading icon
//     return IconButton(
//         icon: AnimatedIcon(
//             icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
//         onPressed: () {
//           close(context, null);
//         });
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // show results based ib selection
//     return Container(
//       height: 100.0,
//       width: 100.0,
//       child: Card(
//         color: Colors.red,
//         child: Center(
//           child: Text(query),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // show when someone searches
//     final suggestionList = query.isEmpty
//         ? recentSearch
//         : cities.where((t) => t.startsWith(query)).toList();

//     return ListView.builder(
//       itemBuilder: (context, index) => ListTile(
//         onTap: () {
//           showResults(context);
//         },
//         leading: Icon(Icons.local_atm),
//         title: RichText(
//           text: TextSpan(
//               text: suggestionList[index].substring(0, query.length),
//               style:
//                   TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//               children: [
//                 TextSpan(
//                     text: suggestionList[index].substring(query.length),
//                     style: TextStyle(color: Colors.grey))
//               ]),
//         ),
//       ),
//       itemCount: suggestionList.length,
//     );
//   }
//

//      showSearch(
//                                       context: context, delegate: DataSearch());
