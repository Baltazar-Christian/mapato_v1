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
                      '${savings[index].amount} - ${savings[index].description}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editSaving(context, savings[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteSaving(context, savings[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          _showSingleSaving(context, savings[index].id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addSaving(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addSaving(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Saving'),
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
                Savings newSaving = Savings(
                  userId: userId,
                  name: _nameController.text,
                  amount: double.parse(_amountController.text),
                  description: _descriptionController.text,
                );
                await DBHelper().insertSavings(newSaving);
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

  void _editSaving(BuildContext context, Savings saving) {
    _nameController.text = saving.name;
    _amountController.text = saving.amount.toString();
    _descriptionController.text = saving.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Saving'),
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
                Savings updatedSaving = Savings(
                  id: saving.id,
                  userId: userId,
                  name: _nameController.text,
                  amount: double.parse(_amountController.text),
                  description: _descriptionController.text,
                );
                await DBHelper().updateSavings(updatedSaving);
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

  void _deleteSaving(BuildContext context, Savings saving) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Saving'),
          content: Text('Are you sure you want to delete this saving?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DBHelper().deleteSavings(saving.id!);
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

  void _showSingleSaving(BuildContext context, int savingId) async {
    Savings savingDetails = await DBHelper().getSavingDetails(savingId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Saving Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${savingDetails.name}'),
              Text('Amount: ${savingDetails.amount}'),
              Text('Description: ${savingDetails.description}'),
            ],
          ),
          actions: [
            TextButton(
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
}
