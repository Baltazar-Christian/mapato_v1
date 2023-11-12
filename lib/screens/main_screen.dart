import 'package:flutter/material.dart';
import 'debts_screen.dart';
import 'earnings_screen.dart';
import 'expenses_screen.dart';
import 'home_screen.dart';
import 'savings_screen.dart';
import 'login_screen.dart'; // Import your login screen file

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Your Logo Widget (Replace this with your actual logo)
            Image.asset(
              'assets/logo.png', // Replace with the path to your logo image
              height: 30, // Adjust the height as needed
              // Other properties like width, color, etc., can be adjusted as needed
            ),
            SizedBox(width: 8), // Add some space between the logo and text
            Text('Mapato'), // Your app name
          ],
        ),
        actions: [
          // Logout Button
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomeScreen(),
          EarningsScreen(),
          SavingsScreen(),
          ExpensesScreen(),
          DebtsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Earnings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'Savings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.money_off), label: 'Expenses'),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: 'Debts'),
        ],
        selectedItemColor: Colors.blue, // Set the selected item color
        unselectedItemColor: Colors.grey, // Set the unselected item color
      ),
    );
  }

  void _logout(BuildContext context) async {
    // Add your logout logic here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
