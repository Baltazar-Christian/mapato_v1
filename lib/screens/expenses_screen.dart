import 'package:flutter/material.dart';
import '../services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Expense> expenses = [];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  late int userId; // Variable to store the user ID
  int? _selectedExpenseId;

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Load the user ID when the widget initializes
    _loadExpenses();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0; // Use the actual default value
  }

  void _loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0; // Use the actual default value
    expenses = await DBHelper().getExpenses(userId);
    setState(() {});
  }

  void _clearControllers() {
    _descriptionController.clear();
    _amountController.clear();
    _dateController.clear();
  }

  Future<void> _showSingleExpense(int expenseId) async {
    // Fetch the expense details based on the provided ID
    Expense expenseDetails = await DBHelper().getExpenseDetails(expenseId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Expense Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Description: ${expenseDetails.description}'),
              Text('Amount: ${expenseDetails.amount}'),
              Text('Date: ${expenseDetails.date}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: expenses.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(expenses[index].description),
                  subtitle: Text(
                      '${expenses[index].amount} - ${expenses[index].date}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editExpense(context, expenses[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteExpense(context, expenses[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          _showSingleExpense(expenses[index].id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addExpense(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addExpense(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Expense newExpense = Expense(
                  userId: userId,
                  description: _descriptionController.text,
                  amount: double.parse(_amountController.text),
                  date: _dateController.text,
                );
                await DBHelper().insertExpense(newExpense);
                _loadExpenses();
                _clearControllers();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editExpense(BuildContext context, Expense expense) {
    _descriptionController.text = expense.description;
    _amountController.text = expense.amount.toString();
    _dateController.text = expense.date;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Expense updatedExpense = Expense(
                  id: expense.id,
                  userId: userId,
                  description: _descriptionController.text,
                  amount: double.parse(_amountController.text),
                  date: _dateController.text,
                );
                await DBHelper().updateExpense(updatedExpense);
                _loadExpenses();
                _clearControllers();
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteExpense(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Expense'),
          content: Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DBHelper().deleteExpense(expense.id!);
                _loadExpenses();
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
