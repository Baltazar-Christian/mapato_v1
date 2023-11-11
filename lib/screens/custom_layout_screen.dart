import 'package:flutter/material.dart';

class CustomLayoutScreen extends StatefulWidget {
  @override
  _CustomLayoutScreenState createState() => _CustomLayoutScreenState();
}

class _CustomLayoutScreenState extends State<CustomLayoutScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Layout'),
      ),
      body: _getBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        // Home page content
        return Center(
          child: Text('Home Page Content'),
        );
      case 1:
        // Settings page content
        return Center(
          child: Text('Settings Page Content'),
        );
      default:
        return Container(); // Return an empty container if the index is not handled
    }
  }
}
