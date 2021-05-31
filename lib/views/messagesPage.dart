import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Authentication.dart';
import 'addTraining.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
                toolbarHeight: 100,
                title: Text('Your Messages'),
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
              TextField(
                controller: myController,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey)),
                style: TextStyle(fontSize: 22, color: Colors.red),
              ),
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
                  child: Text('Find user'),
                ),
              ),
            ])));
  }
}
