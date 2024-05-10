import 'package:flutter/material.dart';
import 'package:lostfound/pages/homePage.dart';
import 'package:lostfound/pages/message.dart';
import 'package:lostfound/pages/report_lost.dart';
import 'package:lostfound/pages/settingpage.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    message(),  // Using correct class name
    ReportLost(),
    SettingPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _pages[_currentIndex],  // Change body based on current index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed, 
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: "Report Lost",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
