import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'exerciseView.dart';

class AddTrainingPage extends StatefulWidget {
  @override
  _AddTrainingPageState createState() => _AddTrainingPageState();
}

class _AddTrainingPageState extends State<AddTrainingPage> {
  final referenceDatabase = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(top: 40, left: 10, right: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: myController,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your traning name',
                          labelText: 'Traning name',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Select date'),
                          ),
                          Text('            ' +
                              currentDate.toString().split(' ')[0]),
                        ],
                      ),
                      new Container(
                          padding:
                              const EdgeInsets.only(left: 150.0, top: 40.0),
                          child: new ElevatedButton(
                            child: const Text('Add Trainig'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                final firebaseUser =
                                    Provider.of<User>(context, listen: false);
                                print(
                                    firebaseUser.uid + "," + myController.text);

                                var inserted = ref
                                    .child('users_tranings')
                                    .child(firebaseUser.uid)
                                    .push();

                                inserted.set({
                                  'name': myController.text,
                                  'time': currentDate.toString().split(' ')[0]
                                });
                                //print(inserted.key);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ExercisePage(inserted.key)));
                              }
                            },
                          )),
                    ],
                  ),
                ))));
  }
}
