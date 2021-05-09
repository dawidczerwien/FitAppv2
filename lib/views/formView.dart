import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final referenceDatabase = FirebaseDatabase.instance;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();
  final myController5 = TextEditingController();
  int _valueCel = 0;
  List<String> _cele = [
    'Gain muscle mass',
    'Maintain your weight',
    'Lose weight'
  ];

  int _valuePlec = 0;
  List<String> _plec = ['Female', 'Male'];
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    // Build a Form widget using the _formKey created above.
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
                          hintText: 'Enter your full name',
                          labelText: 'Name',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: myController2,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.phone),
                          hintText: 'Enter a phone number',
                          labelText: 'Phone',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter valid phone number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: myController3,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.calendar_today),
                          hintText: 'Enter your Age',
                          labelText: 'Age',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter valid Age';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: myController4,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.height),
                          hintText: 'Enter your height in cm',
                          labelText: 'Height',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter valid height';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: myController5,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your weight in kg',
                          labelText: 'Weight',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter valid weight';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Text('Training goal:       ',
                              style: TextStyle(fontSize: 18)),
                          DropdownButton(
                              value: _valueCel,
                              items: [
                                DropdownMenuItem(
                                  child: Text(_cele[0]),
                                  value: 0,
                                ),
                                DropdownMenuItem(
                                  child: Text(_cele[1]),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text(_cele[2]),
                                  value: 2,
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _valueCel = value;
                                });
                              }),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Gender:                 ',
                              style: TextStyle(fontSize: 18)),
                          DropdownButton(
                              value: _valuePlec,
                              items: [
                                DropdownMenuItem(
                                  child: Text(_plec[0]),
                                  value: 0,
                                ),
                                DropdownMenuItem(
                                  child: Text(_plec[1]),
                                  value: 1,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _valuePlec = value;
                                });
                              }),
                        ],
                      ),
                      new Container(
                          padding:
                              const EdgeInsets.only(left: 150.0, top: 40.0),
                          child: new ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                final firebaseUser =
                                    Provider.of<User>(context, listen: false);
                                print(
                                    firebaseUser.uid + "," + myController.text);

                                ref
                                    .child('users_data')
                                    .child(firebaseUser.uid)
                                    .push()
                                    .set({
                                  'name': myController.text,
                                  'phone:': myController2.text,
                                  'age': myController3.text,
                                  'height': myController4.text,
                                  'weight': myController5.text,
                                  'cel': _cele[_valueCel],
                                  'plec': _plec[_valuePlec],
                                  'time': DateTime.now().toString()
                                });
                              }
                            },
                          )),
                    ],
                  ),
                ))));
  }
}
