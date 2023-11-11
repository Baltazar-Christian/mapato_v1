import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the HomeScreen

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to HomeScreen instead of CustomLayoutScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(userName: 'User Name')),
            );
          },
          child: Text('Go to Home Screen'),
        ),
      ),
    );
  }
}
