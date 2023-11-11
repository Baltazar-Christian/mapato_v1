import 'package:flutter/material.dart';
// import 'custom_layout.dart';
import 'custom_layout_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName; // Pass the user name from the login/registration

  HomeScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    return CustomLayoutScreen(
      body: Center(
        child: Text('Your home screen content goes here'),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
}
