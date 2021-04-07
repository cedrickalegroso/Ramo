import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/models/models.dart';

class ListUsers extends StatefulWidget {
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  @override
  Widget build(BuildContext context) {
    //final users = Provider.of<List<UserData>>(context) ?? [];
    final users = context.watch<List<UserData>>() ?? [];
    return ListView.builder(
        padding: EdgeInsets.only(top: 8.0),
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return InkWell(
            onTap: () {
              print('Calling named route with arugment of ${user.uid}');
              Navigator.pushNamed(context, '/profile', arguments: user.uid);
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(user.photoUrl),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('${user.name}')
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  )
                ],
              ),
            ),
          );
        });
  }
}
