
import 'package:flutter/material.dart';
import 'package:savings_application/controller/savings_controller.dart';
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/savingsModel.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_id.dart';

class ChildTransfer extends StatelessWidget {

  final SavingsController savingsController = SavingsController();
  String? userId = UserId().userId;


  final amountController = TextEditingController();
  final milestoneIdController = TextEditingController();
  final poundsController = TextEditingController();
  final penceController = TextEditingController();

  DateTime startDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    final userIdInt = userId != null ? int.tryParse(userId!) : null;

    return Scaffold(
      body: FutureBuilder<List<SavingsModel>>(
        // Ensure userId is provided and convert it to int
        future: savingsController.getSavingsForAccount(userId: userIdInt!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error fetching savings: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No savings found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Data is available, build the scrollable list
          final savings = snapshot.data!;

          // Limit the milestones to show up to 4
          final visibleSavings = savings.take(4).toList();

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
              child: Column(
                children: [
                  // Show up to 4 milestones
                  SizedBox(
                    height: 450,  // Set a fixed height for the scrollable area
                    child: ListView.builder(
                      itemCount: visibleSavings.length,
                      itemBuilder: (context, index) {
                        final savings = visibleSavings[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 4,
                          color: Colors.green.shade50,
                          child: ListTile(
                            title: Text(savings.savId.toString()),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("MilestoneId: ${savings.milestoneId ?? "No ID"}"),
                                Text("Saved: £${savings.amount.toStringAsFixed(2)}"),
                                Text("Date Saved: ${savings.date.toString()}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // If there are more than 4 milestones, show a scrollable "See More" button
                  if (savings.length > 4)
                    TextButton(
                      onPressed: () {
                        // Show more milestones by navigating to another screen or expanding the list
                      },
                      child: Text('See More'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMilestoneDialog(context, userId!);
        },
        backgroundColor: Default.getTitleColour(),
        foregroundColor: Colors.white,
        tooltip: 'Add New Savings',
        child: Icon(Icons.add),
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
                  // Call your controller to add the milestone (no completionDate)
                  final result = savingsController.addSavings(
                    user: account!,
                    amount: amount,
                    date: startDate,
                    milestoneId: int.parse(milestoneId)
                  );

                  if (await result) {
                    Navigator.pop(context); // Close dialog on success
                  } else {
                    // Show SnackBar if milestone creation fails
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