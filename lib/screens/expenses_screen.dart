// expenses_screen.dart

import 'package:flutter/material.dart';
import '../services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DBHelper dbHelper = DBHelper();
  late int _userId; // Added user id variable

  @override
  void initState() {
    super.initState();
    _getUserIdFromSharedPreferences(); // Call the method to retrieve user id
  }

  Future<void> _getUserIdFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId') ?? 0; // Set default value as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Expenses'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addExpense();
              },
              child: Text('Add Expense'),
            ),
            SizedBox(height: 20),
            _showExpenses(),
          ],
        ),
      ),
    );
  }

  Widget _showExpenses() {
    return FutureBuilder<List<Expense>>(
      future: dbHelper.getExpenses(_userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Expense>? expenses = snapshot.data;

            if (expenses != null && expenses.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expenses:'),
                  for (Expense expense in expenses) _buildExpenseTile(expense),
                ],
              );
            } else {
              return Text('No expenses found.');
            }
          }
        }
      },
    );
  }

  Widget _buildExpenseTile(Expense expense) {
    return ListTile(
      title: Text(expense.description),
      subtitle: Text('Amount: \$${expense.amount}, Date: ${expense.date}'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _deleteExpense(expense.id!);
        },
      ),
    );
  }

  Future<void> _addExpense() async {
    String description = _descriptionController.text;
    double amount = double.parse(_amountController.text);
    String date = _dateController.text;

    Expense newExpense = Expense(
      userId: _userId,
      description: description,
      amount: amount,
      date: date,
    );

    await dbHelper.insertExpense(newExpense);

    // Clear text controllers
    _descriptionController.clear();
    _amountController.clear();
    _dateController.clear();

    // Refresh the expenses list
    setState(() {});
  }

  Future<void> _deleteExpense(int expenseId) async {
    await dbHelper.deleteExpense(expenseId);

    // Refresh the expenses list
    setState(() {});
  }
}
