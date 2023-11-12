import 'package:flutter/material.dart';
import 'debts_screen.dart';
import 'earnings_screen.dart';
import 'expenses_screen.dart';
import 'home_screen.dart';
import 'savings_screen.dart';

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
        title: Text('Mapato'),
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
}
