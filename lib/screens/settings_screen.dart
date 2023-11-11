import 'package:flutter/material.dart';
import 'custom_layout_screen.dart';
import 'home_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutScreen(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Add your settings widgets here
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.blue,
        currentIndex: 1, // Set the current index to indicate active item
        onTap: (index) {
          // Handle bottom navigation bar item taps
          if (index == 0) {
            // Navigate to the Home screen
            _navigateToHomeScreen(context);
          } else {
            // Stay on the Settings screen or perform other actions if needed
          }
        },
      ),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    // Add logic to navigate to the Home screen or perform other actions
    // For example:
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
