import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database.dart';

class EarningsScreen extends StatefulWidget {
  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  List<Earning> earnings = [];
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  late int userId; // Variable to store the user ID

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Load the user ID when the widget initializes
    _loadEarnings();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0; // Use the actual default value
    print('User ID: $userId');
  }

  void _loadEarnings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt('userId') ?? 0; // Use the actual default value
    earnings = await DBHelper().getEarnings(userId);
    setState(() {});
  }

  void _clearControllers() {
    _sourceController.clear();
    _amountController.clear();
    _dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: earnings.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: earnings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(earnings[index].source),
                  subtitle: Text(
                      '${earnings[index].amount} - ${earnings[index].date}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editEarning(context, earnings[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteEarning(context, earnings[index]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEarning(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addEarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Earning'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _sourceController,
                decoration: InputDecoration(labelText: 'Source'),
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
                Earning newEarning = Earning(
                  userId: userId,
                  source: _sourceController.text,
                  amount: double.parse(_amountController.text),
                  date: _dateController.text,
                );
                await DBHelper().insertEarning(newEarning);
                _loadEarnings();
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

  void _editEarning(BuildContext context, Earning earning) {
    _sourceController.text = earning.source;
    _amountController.text = earning.amount.toString();
    _dateController.text = earning.date;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Earning'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _sourceController,
                decoration: InputDecoration(labelText: 'Source'),
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
                Earning updatedEarning = Earning(
                  id: earning.id,
                  userId: userId,
                  source: _sourceController.text,
                  amount: double.parse(_amountController.text),
                  date: _dateController.text,
                );
                await DBHelper().updateEarning(updatedEarning);
                _loadEarnings();
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

  void _deleteEarning(BuildContext context, Earning earning) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Earning'),
          content: Text('Are you sure you want to delete this earning?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await DBHelper().deleteEarning(earning.id!);
                _loadEarnings();
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
