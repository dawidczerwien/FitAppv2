import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final chatId;

  ChatPage(this.chatId);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final myMessage = TextEditingController();
  Query _ref;
  var firebaseUser;
  final ScrollController _listScrollController = new ScrollController();

  @override
  void initState() {
    firebaseUser = Provider.of<User>(context, listen: false);
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('messages')
        .child(widget.chatId)
        .orderByChild('date');
  }

  Widget _buildContactItem({Map msg, var key, bool sendByMe}) {
    return Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: sendByMe ? 0 : 24,
            right: sendByMe ? 24 : 0),
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.redAccent,
            ),
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 10),
            //margin: EdgeInsets.only(top: 20, left: 20, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg['messageText'],
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  msg['date'].split('.')[0],
                  style: TextStyle(fontSize: 12),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              child: Column(children: [
        Expanded(
            child: FirebaseAnimatedList(
                query: _ref,
                sort: (DataSnapshot a, DataSnapshot b) =>
                    b.key.compareTo(a.key), //fixed
                reverse: true,
                controller: _listScrollController,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map msg = snapshot.value;
                  bool sendByMe = false;
                  if (msg['sender'] == firebaseUser.email) {
                    sendByMe = true;
                  }

                  return _buildContactItem(
                      msg: msg, key: snapshot.key, sendByMe: sendByMe);
                })),
        Stack(
          children: [
            Container(
              color: Colors.red,
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: myMessage,
                      decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (myMessage.text.isNotEmpty) {
                          FirebaseDatabase.instance
                              .reference()
                              .child('messages')
                              .child(widget.chatId)
                              .push()
                              .set({
                            'messageText': myMessage.text,
                            'sender': firebaseUser.email,
                            'date': DateTime.now().toString()
                          });
                          myMessage.text = "";
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ]))),
    );
  }
}
