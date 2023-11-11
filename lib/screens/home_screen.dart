import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loader while fetching user details
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // If the Future is complete, display the user details
          if (snapshot.hasError) {
            // Handle errors
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            // Return the HomeScreen with user details
            return _buildHomeScreen(context, snapshot.data);
          }
        }
      },
    );
  }

  Future<String> _getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? 'User';
  }

  Widget _buildHomeScreen(BuildContext context, userName) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $userName'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Remove user details from shared preferences on logout
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.clear();

              // Navigate back to the RegistrationScreen
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}
