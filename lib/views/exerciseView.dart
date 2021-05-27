import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addExercise.dart';

class AddExercisePage extends StatefulWidget {
  final trainingKey;

  AddExercisePage(this.trainingKey);

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  Query _ref;

  void initState() {
    super.initState();
    final firebaseUser = Provider.of<User>(context, listen: false);
    _ref = FirebaseDatabase.instance
        .reference()
        .child('users_tranings')
        .child(firebaseUser.uid)
        .child(widget.trainingKey);
  }

  Widget _buildContactItem({Map notes, var key}) {
    return Container(
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
              notes['name'] ?? 'default',
              style: TextStyle(fontSize: 22, color: Colors.white),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      minimum: const EdgeInsets.all(56.0),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddExcercisePage('chest', widget.trainingKey)));
                  },
                  child: CircleAvatar(
                      radius: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/fir-database-e91a5.appspot.com/o/klatka.jpg?alt=media&token=1a36212a-ed3b-4ce7-92c6-6714609060ee',
                          width: 62,
                          height: 62,
                          fit: BoxFit.fitHeight,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ))),
              new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddExcercisePage('biceps', widget.trainingKey)));
                  },
                  child: CircleAvatar(
                      radius: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/fir-database-e91a5.appspot.com/o/biceps.jpg?alt=media&token=d88c9e6d-c56a-4aa0-9993-6bcae3c92c19',
                          width: 62,
                          height: 62,
                          fit: BoxFit.fitHeight,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ))),
              new GestureDetector(
                  onTap: () {
                    print("Container3 clicked");
                  },
                  child: CircleAvatar(
                      radius: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/fir-database-e91a5.appspot.com/o/triceps.jpg?alt=media&token=68b007f0-51f7-4a03-9164-9a1874436b60',
                          width: 62,
                          height: 62,
                          fit: BoxFit.fitHeight,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ))),
              new GestureDetector(
                  onTap: () {
                    print("Container4 clicked");
                  },
                  child: CircleAvatar(
                      radius: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/fir-database-e91a5.appspot.com/o/plecy.jpg?alt=media&token=b1b0ad96-6a1e-4b53-bcf2-200b8bb47f26',
                          width: 62,
                          height: 62,
                          fit: BoxFit.fitHeight,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ))),
            ],
          ),
          Expanded(
              child: FirebaseAnimatedList(
                  query: _ref,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    print(snapshot.value);
                    if (snapshot.value.runtimeType != String) {
                      Map notes = snapshot.value;
                      return _buildContactItem(notes: notes, key: snapshot.key);
                    } else {
                      return null;
                    }
                  })),
        ],
      ),
    ));
  }
}
