import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramo/misc/clipper.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/services/authService.dart';

class DashboardWrapper extends StatefulWidget {
  @override
  _DashboardWrapperState createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserData>();
    final screenData = MediaQuery.of(context);
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
                              width: screenData.size.height / 40,
                            ),
                            Text('Jennie Kim',
                                style: TextStyle(
                                    fontSize: screenData.size.height / 50,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      )),
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
