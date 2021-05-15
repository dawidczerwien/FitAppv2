import 'package:flutter/material.dart';

import 'addTraining.dart';

class WorkoutListPage extends StatefulWidget {
  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class AddWorkoutpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      body: Container(
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                      side: BorderSide(color: Colors.white)))),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddTrainingPage()));
          },
          child: Text('Add Workout'),
        ),
      ),
    ));
  }
}
