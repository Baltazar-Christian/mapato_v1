import 'package:flutter/material.dart';

class CustomLayoutScreen extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;

  CustomLayoutScreen({required this.body, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App Name'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout logic here
              // For example, navigate back to the RegistrationScreen
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
