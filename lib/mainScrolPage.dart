import 'package:flutter/material.dart';
import 'loginWindow.dart';
import 'registerWindow.dart';

class ScrollMainpage extends StatefulWidget {
  @override
  _ScrollMainpageState createState() => _ScrollMainpageState();
}

class _ScrollMainpageState extends State<ScrollMainpage> {
  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  Widget loginMainPage() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.redAccent,
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: NetworkImage(
                  "https://images.theconversation.com/files/380799/original/file-20210127-17-if809z.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=1200.0&fit=crop"),
              fit: BoxFit.cover)),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 220),
            child: Text(
              'Fit App',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 20),
              width: 305,
              height: 70,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                            side: BorderSide(color: Colors.white)))),
                onPressed: () {
                  _controller.animateToPage(
                    0,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.ease,
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              )),
          Container(
              margin: EdgeInsets.only(top: 20),
              width: 305,
              height: 70,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                            side: BorderSide(color: Colors.red)))),
                onPressed: () {
                  _controller.animateToPage(
                    2,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.ease,
                  );
                },
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      height: MediaQuery.of(context).size.height,
      child: PageView(
        controller: _controller,
        physics: new AlwaysScrollableScrollPhysics(),
        children: <Widget>[LoginPage(), loginMainPage(), RegisterPage()],
        scrollDirection: Axis.horizontal,
      ),
    ));
  }
}
