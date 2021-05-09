import 'package:flutter/material.dart';
import 'formView.dart';

class TestSite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                            side: BorderSide(color: Colors.white)))),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyCustomForm()));
                },
                child: Text(
                  'Fill form',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}
