import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ramo/models/models.dart';
import 'package:ramo/services/databaseService.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class AddPostCom extends StatefulWidget {
  AddPostCom({Key key}) : super(key: key);

  @override
  _AddPostComState createState() => _AddPostComState();
}

class _AddPostComState extends State<AddPostCom> {
  final DatabaseService _postService = DatabaseService();
  String text = '';
  bool hasIMG = false;
  bool isBusy = false;

  File _imageFile;
  final _imagePicker = ImagePicker();

  Future getImage() async {
    final image = await _imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(image.path);
      hasIMG = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenData = MediaQuery.of(context);

    final userData = context.watch<UserData>();

    _sendToDB(text) async {
      if (hasIMG) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('postIMGS')
            .child(
                '/${userData.uid}-${DateTime.now().millisecondsSinceEpoch}.png');

        firebase_storage.UploadTask uploadTask;
        uploadTask = ref.putFile(_imageFile);
        await uploadTask;
        ref.getDownloadURL().then((fileUrl) {
          print('upload Complete $fileUrl');

          _postService.savePostWithImage(fileUrl, text);
        });

        return;
      }

      _postService.savePost(text);
    }

    Future startPost(text) async {
      setState(() {
        isBusy = true;
      });

      await _sendToDB(text);

      setState(() {
        isBusy = false;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Tweet'),
          actions: <Widget>[
            FlatButton(
                textColor: Colors.white,
                onPressed: () async {
                  startPost(text);
                  //   Navigator.pop(context);
                },
                child: Text('Post'))
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: isBusy != true
                ? hasIMG != true
                    ? Form(
                        child: TextFormField(
                          onChanged: (val) {
                            setState(() {
                              text = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Write something engaging',
                            suffixIcon: IconButton(
                                icon: Icon(Icons.add_a_photo),
                                onPressed: getImage),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Form(
                            child: TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  text = val;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Write something engaging',
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: getImage),
                              ),
                            ),
                          ),
                          Image.file(_imageFile),
                        ],
                      )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(
                        height: screenData.size.height / 20,
                      ),
                      Center(
                        child: Text('Posting Your post please wait.'),
                      )
                    ],
                  )));
  }
}
