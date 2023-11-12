import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Earnings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Savings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.money_off),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Debts',
        ),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor:
          Colors.grey, // Set the color of unselected icons to gray
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
