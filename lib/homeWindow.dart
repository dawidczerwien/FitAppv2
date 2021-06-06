import 'package:flutter/material.dart';
import 'views/homeView.dart';
import 'views/messagesPage.dart';
import 'views/workoutListView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> pages = [
    MainPage(),
    WorkoutListPage(),
    MessagesPage(),
  ];
  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.red,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Main Page',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Trainings',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Your messages',
          ),
        ],
      ),
    );
  }
}
