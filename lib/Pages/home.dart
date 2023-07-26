import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'calander.dart';
import 'profile.dart';
import 'upcomingEvents.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void contactsScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/alumini');
  }

  void ourTeamScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/ourTeam');
  }

  void aboutUsScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/searchEvents');
  }

  void newsScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/news');
  }

  void recordingScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/recording');
  }

  void resultsScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/results');
  }

  void feedbackScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/feedback');
  }

  final List<Map<String, dynamic>> _pages = [
    {'Pages': upcomingEvents(), 'title': 'Upcoming Events'},
    {'Pages': CalanderScreen(), 'title': 'Events'},
    {'Pages': profilePage(), 'title': 'Profile'},
  ];
  int _SeletedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _SeletedPageIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        // initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xFF613FE5),
            ),
            backgroundColor: Color(0xFFF6F6F7),
            title: Text(
              _pages[_SeletedPageIndex]['title'],
              style: TextStyle(
                fontFamily: 'Lexend Deca',
                color: Color(0xFF120E16),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  color: Color(0xFF120E16),
                  child: Text(
                    'Janganlah Bermalas-malasan!',
                     textAlign: TextAlign.center,
                    style: TextStyle(
                      
                      color: Color(0xFFF6F6F7),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Color(0xFF613FE5), size: 32),
                  title: Text(
                    'Search Events',
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/searchEvents');
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Color(0xFF613FE5),
                    size: 32,
                  ),
                  title: Text(
                    'Booked Events',
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/bookedEvents');
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                ListTile(
                  leading: Icon(Icons.person_outline,
                      color: Color(0xFF613FE5), size: 32),
                  title: Text(
                    'Create Events (Associate Only)',
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/createEvents');
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                ListTile(
                  leading:
                      Icon(Icons.newspaper, color: Color(0xFF613FE5), size: 32),
                  title: Text(
                    'Event Managements (Associate Only)',
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/eventManagements');
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                ListTile(
                  leading: Icon(Icons.feedback_outlined,
                      color: Color(0xFF613FE5), size: 32),
                  title: Text(
                    'Feedback/Suggestions',
                    style: TextStyle(fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/feedback');
                  },
                ),
              ],
            ),
          ),
          body: _pages[_SeletedPageIndex]['Pages'],
          bottomNavigationBar: CurvedNavigationBar(
            index: 0,
            height: 60.0,
            items: <Widget>[
              Icon(
                Icons.home,
                size: 30,
                color: Color(0xFFF6F6F7),
              ),
              Icon(
                Icons.event,
                size: 30,
                color: Color(0xFFF6F6F7),
              ),
              Icon(
                Icons.person,
                size: 30,
                color: Color(0xFFF6F6F7),
              )
            ],
            color: Color(0xFF120E16),
            buttonBackgroundColor: Color(0xFF613FE5),
            backgroundColor: Color(0xFFF6F6F7),
            animationCurve: Curves.easeInOutSine,
            animationDuration: Duration(milliseconds: 600),
            onTap: (index) {
              setState(() {
                _SeletedPageIndex = index;
              });
            },
          ),
        ));
  }
}