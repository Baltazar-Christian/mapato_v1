import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/database.dart';

class DebtScreen extends StatefulWidget {
  @override
  _DebtScreenState createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  late List<Debt> debts;
  late int userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadDebts();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
  }

  void _loadDebts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
    debts = await DBHelper().getDebts(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildDebtList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDebtDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDebtList() {
    return ListView.builder(
      itemCount: debts.length,
      itemBuilder: (context, index) {
        Debt debt = debts[index];
        return ListTile(
          title: Text(debt.description),
          subtitle: Text('Amount: \$${debt.amount}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteDebt(debt.id!);
            },
          ),
          onTap: () {
            _showSingleDebt(debt.id!);
          },
        );
      },
    );
  }

  void _showDebtDialog(BuildContext context, {Debt? debt}) {
    final TextEditingController amountController =
        TextEditingController(text: debt?.amount.toString() ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: debt?.description ?? '');
    final TextEditingController ownerController =
        TextEditingController(text: debt?.owner ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(debt == null ? 'Add Debt' : 'Edit Debt'),
          content: Container(
            width: double.minPositive,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: ownerController,
                  decoration: InputDecoration(labelText: 'Owner'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                double amount = double.parse(amountController.text);
                String description = descriptionController.text;
                String owner = ownerController.text;

                if (debt == null) {
                  await DBHelper().insertDebt(
                    Debt(
                      userId: userId,
                      amount: amount,
                      pamount: 0.0,
                      description: description,
                      owner: owner,
                    ),
                  );
                } else {
                  debt.amount = amount;
                  debt.description = description;
                  debt.owner = owner;

                  await DBHelper().updateDebt(debt);
                }

                _loadDebts();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteDebt(int debtId) async {
    await DBHelper().deleteDebt(debtId);
    _loadDebts();
  }

  void _showSingleDebt(int debtId) async {
    Debt debtDetails = await DBHelper().getDebtDetail(debtId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Debt Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Amount: \$${debtDetails.amount}'),
              Text('Description: ${debtDetails.description}'),
              Text('Owner: ${debtDetails.owner}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
