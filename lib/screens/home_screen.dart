import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'registration_screen.dart';

class HomeScreen extends StatelessWidget {
  late BuildContext context;

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
            return _buildHomeScreen(snapshot.data);
          }
        }
      },
    );
  }

  Future<String> _getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? 'User';
  }

  Widget _buildHomeScreen(userName) {
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: [
          _buildCard('Earnings', Colors.green),
          _buildCard('Savings', Colors.yellow),
          _buildCard('Expenses', Colors.orange),
          _buildCard('Debts', Colors.red),
        ],
      ),
    );
  }

  Widget _buildCard(String title, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            // Add other content as needed
          ],
        ),
      ),
    );
  }
}
