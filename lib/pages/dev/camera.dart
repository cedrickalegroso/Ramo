import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  File _imageFile;
  final _imagePicker = ImagePicker();

  // @override
  // void initState() {
  //   super.initState();
  // }
  // Future getImage(source) async {
  //   final pickedFile = await ImagePicker.platform.pickImage(source: source);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _imageFile = pickedFile as File;
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }
  //

  Future getImage() async {
    final image = await _imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(image.path);
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Center(
        child: _imageFile == null ? Text('No image selected') : _imageFile,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.camera_alt_rounded),
        onPressed: getImage,
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
