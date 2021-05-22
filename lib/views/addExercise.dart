import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExcercisePage extends StatefulWidget {
  final type;
  final trainigKey;
  AddExcercisePage(this.type, this.trainigKey);

  @override
  _AddExcercisePageState createState() => _AddExcercisePageState();
}

class _AddExcercisePageState extends State<AddExcercisePage> {
  final myController = TextEditingController();
  Query _ref;

  void initState() {
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('exercises')
        .child(widget.type);
  }

  Widget _buildContactItem({Map notes, var key, int likes, Map usersLiked}) {
    final firebaseUser = Provider.of<User>(context, listen: false);
    return SafeArea(
        child: Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20.0,
                    offset: Offset(10, 20))
              ],
            ),
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 10),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notes['name'],
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                Row(children: [
                  IconButton(
                      onPressed: () {
                        final firebaseUser =
                            Provider.of<User>(context, listen: false);
                        FirebaseDatabase.instance
                            .reference()
                            .child('users_tranings')
                            .child(firebaseUser.uid)
                            .child(widget.trainigKey)
                            .push()
                            .set({
                          'id': key,
                          'type': widget.type,
                          'name': notes['name']
                        }).then((value) => Navigator.pop(context));
                        //print(widget.trainigKey);
                      },
                      icon: Icon(Icons.my_library_add_outlined)),
                  IconButton(
                      onPressed: () {
                        final firebaseUser =
                            Provider.of<User>(context, listen: false);
                        if (!usersLiked.containsValue(firebaseUser.uid)) {
                          FirebaseDatabase.instance
                              .reference()
                              .child('exercises')
                              .child(widget.type)
                              .child(key)
                              .child('usersLiked')
                              .push()
                              .set(firebaseUser.uid);
                        } else {
                          usersLiked.forEach((id, value) {
                            //print(key);
                            if (value == firebaseUser.uid) {
                              print(key);
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('exercises')
                                  .child(widget.type)
                                  .child(key)
                                  .child('usersLiked')
                                  .child(id)
                                  .remove();
                            }
                          });
                        }
                      },
                      icon: Icon(
                        Icons.thumb_up,
                        color: usersLiked.containsValue(firebaseUser.uid)
                            ? Colors.green
                            : Colors.black,
                      )),
                  Text(likes.toString())
                ]),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FirebaseAnimatedList(
            query: _ref,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map notes = snapshot.value;
              Map usersDict = notes['usersLiked'];
              int numberOflikes = 0;

              print('numberofLikes');
              try {
                numberOflikes = usersDict.keys.length;
              } catch (ex) {
                print(ex);
              }

              print(numberOflikes);

              if (usersDict == null) {
                usersDict = {null: 'null'};
              }
              print('test');
              print(notes['usersLiked']);
              return _buildContactItem(
                  notes: notes,
                  key: snapshot.key,
                  likes: numberOflikes,
                  usersLiked: usersDict);
            }));
  }
}
