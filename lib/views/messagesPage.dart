import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Authentication.dart';
import 'chatPage.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final referenceDatabase = FirebaseDatabase.instance;
  final myController = TextEditingController();
  DataSnapshot searchResultSnapshot;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget userTile(String userEmail, String userId) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              //sendMessage(userName);
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(24)),
                child: GestureDetector(
                  onTap: () {
                    final firebaseUser =
                        Provider.of<User>(context, listen: false);
                    print(firebaseUser.uid + '_' + userId);
                    final ref = referenceDatabase.reference();

                    var db2 = FirebaseDatabase.instance
                        .reference()
                        .child('messages')
                        .child(firebaseUser.uid + '_' + userId);
                    db2.once().then((DataSnapshot snapshot) {
                      print(snapshot.key);
                      if (snapshot.value == null) {
                        var db3 = FirebaseDatabase.instance
                            .reference()
                            .child('messages')
                            .child(userId + '_' + firebaseUser.uid);
                        db3.once().then((DataSnapshot snapshot) {
                          print(snapshot.key);
                          if (snapshot.value == null) {
                            ref
                                .child('messages')
                                .child(firebaseUser.uid + '_' + userId)
                                .push()
                                .set({'messages': 0});
                          } else {
                            print("exists");
                          }
                        });
                      } else {
                        print("exists");
                      }
                    });

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ChatPage()));
                  },
                  child: Text(
                    "Message",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )),
          )
        ],
      ),
    );
  }

  bool haveUserSearched = false;
  bool isLoading = false;
  List<dynamic> myList = [];
  List<dynamic> myListId = [];

  initiateSearch() async {
    if (myController.text.isNotEmpty) {
      setState(() {
        myList = [];
      });
      var db = FirebaseDatabase.instance.reference().child('users');
      db.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;

        values.forEach((key, values) {
          if (values['email'].toString().contains(myController.text)) {
            myList.add(values["email"]);
            myListId.add(values['userId']);
          }
          //print(values['email']);
        });

        print(myList);
        setState(() {
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: myList.length,
            itemBuilder: (context, index) {
              return userTile(myList[index], myListId[index]);
            })
        : Container();
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
            body: SingleChildScrollView(
                child: Column(children: [
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
                    initiateSearch();
                  },
                  child: Text('Find user'),
                ),
              ),
              userList()
            ]))));
  }
}
