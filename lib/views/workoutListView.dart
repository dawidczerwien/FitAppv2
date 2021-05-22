import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Authentication.dart';
import 'addTraining.dart';
import 'exerciseView.dart';

class WorkoutListPage extends StatefulWidget {
  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  Query _ref;

  void initState() {
    super.initState();
    final firebaseUser = Provider.of<User>(context, listen: false);
    _ref = FirebaseDatabase.instance
        .reference()
        .child('users_tranings')
        .child(firebaseUser.uid);
  }

  Widget _buildContactItem({Map notes, var key}) {
    return new GestureDetector(
        onTap: () {
          print(notes['name']);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddExercisePage(key)));
        },
        child: Container(
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20.0,
                      offset: Offset(10, 20))
                ]),
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 10),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notes['name'] ?? 'default',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    )),
                Text(
                  notes['time'],
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
                toolbarHeight: 100,
                title: Text('Your Trainings'),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                          onTap: () {
                            context.read<AuthenticationService>().signOut();
                          },
                          child: new Container(
                              width: 50,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.cancel,
                                size: 46.0,
                              )))),
                ]),
            body: Column(children: [
              Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                              side: BorderSide(color: Colors.white)))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddTrainingPage()));
                  },
                  child: Text('Add Workout'),
                ),
              ),
              Expanded(
                  child: FirebaseAnimatedList(
                      query: _ref,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        print(snapshot.key);
                        if (snapshot.value.runtimeType != String) {
                          Map notes = snapshot.value;
                          return _buildContactItem(
                              notes: notes, key: snapshot.key);
                        } else {
                          return null;
                        }
                      })),
            ])));
  }
}
