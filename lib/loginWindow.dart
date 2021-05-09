import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Authentication.dart';

class LoginPage extends StatelessWidget {
  final email = TextEditingController();
  final passwd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: NetworkImage(
                  "https://images.theconversation.com/files/380799/original/file-20210127-17-if809z.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=1200.0&fit=crop"),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 170),
          ),
          TextField(
            controller: email,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelText: "Email",
                labelStyle: TextStyle(fontSize: 16, color: Colors.grey)),
            style: TextStyle(fontSize: 22, color: Colors.red),
          ),
          TextField(
            obscureText: true,
            controller: passwd,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelText: "Hasło",
                labelStyle: TextStyle(fontSize: 16, color: Colors.grey)),
            style: TextStyle(fontSize: 22, color: Colors.red),
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                            side: BorderSide(color: Colors.white)))),
                onPressed: () {
                  context.read<AuthenticationService>().signIn(
                        email: email.text.trim(),
                        password: passwd.text.trim(),
                      );
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              )),
          Container(
            width: 200,
            height: 50,
            margin: EdgeInsets.only(top: 20),
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                            side: BorderSide(color: Colors.white)))),
                onPressed: () {
                  try {
                    context
                        .read<AuthenticationService>()
                        .sendResetPasswordEmail(email: email.text.trim());
                  } catch (e) {
                    return e;
                  }
                },
                child: Text(
                  'Reset password',
                  style: TextStyle(fontSize: 20),
                )),
          ),
        ],
      ),
    )));
  }
}
