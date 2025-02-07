import 'package:flutter/material.dart';
import 'package:savings_application/controller/milestoneController.dart';
import 'package:savings_application/controller/savings_controller.dart';
import 'package:savings_application/helpers/date_time_helper.dart';
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/savingsModel.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_id.dart';

class ChildTransfer extends StatefulWidget {
  @override
  _ChildTransferState createState() => _ChildTransferState();
}

class _ChildTransferState extends State<ChildTransfer> {
  final SavingsController savingsController = SavingsController();
  final MilestoneController milestoneController = MilestoneController();
  String? userId = UserId().userId;
  late Future<List<SavingsModel>> savingsFuture;

  final amountController = TextEditingController();
  final milestoneIdController = TextEditingController();
  final poundsController = TextEditingController();
  final penceController = TextEditingController();

  DateTime startDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    refreshSavings();
  }

  void refreshSavings() {
    final userIdInt = userId != null ? int.tryParse(userId!) : null;
    if (userIdInt != null) {
      setState(() {
        savingsFuture = savingsController.getSavingsForAccount(userId: userIdInt);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddMilestoneDialog(context, userId!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(300, 50),
              ),
              child: Text("Add Savings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SavingsModel>>(
              future: savingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error fetching savings: \${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No savings found.",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                final savings = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 450, // Set an appropriate height
                      child: ListView.builder(
                        itemCount: savings.length,
                        itemBuilder: (context, index) {
                          final savingsItem = savings[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            elevation: 4,
                            color: Colors.green.shade50,
                            child: ListTile(
                              title: Text(savingsItem.savId.toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("MilestoneId: ${savingsItem.milestoneId ?? 'No ID'}"),
                                  Text("Saved: £${savingsItem.amount.toStringAsFixed(2)}"),
                                  Text("Date Saved: ${convertDateTimeToString(savingsItem.date)}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMilestoneDialog(BuildContext context, String userId) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Savings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'User ID'),
                  initialValue: userId,
                  enabled: false, // User ID should not be editable
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: poundsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Pounds (£)'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: penceController,
                        keyboardType: TextInputType.number,
                        maxLength: 2, // Limit to 2 digits
                        decoration: InputDecoration(
                          labelText: 'Pence',
                          counterText: '', // Hides the character count
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: milestoneIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Milestone ID'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Parse pounds and pence values
                final pounds = int.tryParse(poundsController.text) ?? 0;
                final pence = int.tryParse(penceController.text) ?? 0;

                final milestoneId = milestoneIdController.text;

                // Ensure pence is between 0 and 99
                if (pence < 0 || pence > 99) {
                  print("Pence must be between 0 and 99");
                  return;
                }

                // Calculate the targetAmount
                final amount = pounds + (pence / 100);

                AccountModel? account = UserAccount().getAccount();
                print("Retrieved account: $account");

                if (amount.toString().isNotEmpty && milestoneId.isNotEmpty) {
                  // Call your controller to add the savings (no completionDate)
                  final result = await savingsController.addSavings(
                      user: account!,
                      amount: amount,
                      date: startDate,
                      milestoneId: int.parse(milestoneId)
                  );

                  if (result) {
                    // Call updateSavedAmount after successful savings creation
                    final updateResult = await milestoneController.updateSavedAmount(
                      milestoneId: int.parse(milestoneId),
                      addedAmount: amount,
                    );

                    if (updateResult) {
                      // Update successful, refresh the savings and pop the context
                      refreshSavings();
                      Navigator.pop(context); // Close dialog on success
                    } else {
                      // Handle failure to update the saved amount
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update saved amount for milestone!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    // Show SnackBar if savings creation fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create milestone!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  print("ERROR: Missing required fields.");
                }
              },

              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}