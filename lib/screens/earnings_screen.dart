// earnings_screen.dart

import 'package:flutter/material.dart';
// import 'package:your_app_name/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/database.dart';

class EarningsScreen extends StatefulWidget {
  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  late int userId;
  List<Earning> earnings = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadEarnings();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
  }

  Future<void> _loadEarnings() async {
    DBHelper dbHelper = DBHelper();
    List<Earning> loadedEarnings = await dbHelper.getEarnings(userId);
    setState(() {
      earnings = loadedEarnings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings'),
      ),
      body: ListView.builder(
        itemCount: earnings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(earnings[index].source),
            subtitle: Text('Amount: ${earnings[index].amount}'),
            // Add other earning details as needed
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add logic to add a new earning
          // For example, navigate to a screen to add a new earning
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
