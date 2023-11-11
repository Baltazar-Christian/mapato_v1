// login_screen.dart

import 'package:flutter/material.dart';
import '../services/database.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _loginUser(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginUser(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    User? user = await dbHelper.getUserByEmail(email);

    Navigator.pop(context); // Close the dialog

    if (user != null && user.password == password) {
      print('Login successful');
      _navigateToHomeScreen(context, user);
    } else {
      print('Login failed');
    }
  }

  void _navigateToHomeScreen(BuildContext context, User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(userName: user.name)),
    );
  }
}
