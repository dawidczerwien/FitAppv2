import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class CreateExercisePage extends StatefulWidget {
  final typeExercise;

  CreateExercisePage(this.typeExercise);

  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final referenceDatabase = FirebaseDatabase.instance;
  DateTime _chosenDateTime = DateTime.now();
  var img;
  final myController = TextEditingController();
  final myControllerDesc = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myControllerDesc.dispose();
    super.dispose();
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  Future uploadPic() async {
    if (_image == null) {
      return null;
    }
    String fileName = basename(_image.path);
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('users_exercise_photos/')
        .child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    await uploadTask;
    String url = await firebaseStorageRef.getDownloadURL();
    setState(() {
      print("Profile Picture uploaded: $url");
    });
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Exercise name: ',
              style: TextStyle(fontSize: 25),
            ),
            TextField(
              controller: myController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.multiline,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 2,
            ),
            Text(
              'Exercise description: ',
              style: TextStyle(fontSize: 25),
            ),
            TextField(
              controller: myControllerDesc,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.multiline,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      getImage();
                    },
                    icon: Icon(Icons.photo_library)),
                CircleAvatar(
                  radius: 140,
                  backgroundColor: Colors.white,
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _image,
                            width: 230,
                            height: 230,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          width: 170,
                          height: 170,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                )
              ],
            ),
            new Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    final firebaseUser =
                        Provider.of<User>(context, listen: false);

                    uploadPic().then((value) {
                      ref
                          .child('exercises')
                          .child(widget.typeExercise)
                          .push()
                          .set({
                        'name': myController.text,
                        'description': myControllerDesc.text,
                        'userId': firebaseUser.uid,
                        'iserName': firebaseUser.email,
                        'time': _chosenDateTime.toString(),
                        'image': value,
                        'likes': 0
                      });
                      myController.text = '';
                    });
                  },
                  child: Text('Save to firebase')),
            )
          ],
        ),
      ),
    ));
  }
}
