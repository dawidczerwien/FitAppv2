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

  Widget _buildContactItem({Map notes, var key}) {
    return SafeArea(
        child: Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.red,
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
                Center(
                  child: IconButton(
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
                ),
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
              return _buildContactItem(notes: notes, key: snapshot.key);
            }));
  }
}
