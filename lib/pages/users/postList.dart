import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/services/databaseService.dart';

class ListPosts extends StatefulWidget {
  ListPosts({Key key}) : super(key: key);

  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  // DatabaseService _userService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    // final posts = Provider.of<List<Posts>>(context) ?? [];
    final posts = context.watch<List<Posts>>() ?? [];
    final _userService = context.read<DatabaseService>();
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return posts != null
            ? StreamBuilder(
                stream: _userService.getUserInfo(post.creator),
                builder:
                    (BuildContext context, AsyncSnapshot<UserData> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListTile(
                    title: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        children: [
                          snapshot.data.photoUrl != ''
                              ? CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(snapshot.data.photoUrl))
                              : Icon(Icons.person, size: 40),
                          SizedBox(width: 10),
                          Text(snapshot.data.name)
                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              post.postType != 1
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [Text(post.text)],
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(post.text),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Image.network(post.fileUrl)
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                })
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
      },
    );
  }
}
