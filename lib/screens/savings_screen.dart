import 'package:flutter/material.dart';
import '../services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingsScreen extends StatefulWidget {
  @override
  _SavingsScreenState createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  List<Savings> savings = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late int userId; // Variable to store the user ID

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Load the user ID when the widget initializes
    _loadSavings();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0; // Use the actual default value
    print('User ID: $userId');
  }

  void _loadSavings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt('userId') ?? 0; // Use the actual default value
    savings = await DBHelper().getSavings(userId);
    setState(() {});
  }

  void _clearControllers() {
    _nameController.clear();
    _amountController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: savings.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: savings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(savings[index].name),
                  subtitle: Text(
                      'Amount: ${savings[index].amount}, Description: ${savings[index].description}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editSavings(context, savings[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteSavings(context, savings[index]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addSavings(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addSavings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Savings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
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
                Savings newSavings = Savings(
                  userId: userId,
                  name: _nameController.text,
                  amount: double.parse(_amountController.text),
                  description: _descriptionController.text,
                );
                await DBHelper().insertSavings(newSavings);
                _loadSavings();
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

  void _editSavings(BuildContext context, Savings savings) {
    _nameController.text = savings.name;
    _amountController.text = savings.amount.toString();
    _descriptionController.text = savings.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Savings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
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
                Savings updatedSavings = Savings(
                  id: savings.id,
                  userId: userId,
                  name: _nameController.text,
                  amount: double.parse(_amountController.text),
                  description: _descriptionController.text,
                );
                await DBHelper().updateSavings(updatedSavings);
                _loadSavings();
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

  void _deleteSavings(BuildContext context, Savings savings) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Savings'),
          content: Text('Are you sure you want to delete this savings?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DBHelper().deleteSavings(savings.id!);
                _loadSavings();
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
