import 'package:flutter/material.dart';
import 'package:savings_application/controller/account_controller.dart';
import 'package:savings_application/controller/milestoneController.dart';
import 'package:savings_application/controller/savings_controller.dart';
import 'package:savings_application/helpers/helpers.dart';
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/milestoneModel.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_active_milestone.dart';
import 'package:savings_application/user/user_id.dart';

class ParentMilestonePage extends StatefulWidget {
  @override
  _ParentMilestoneState createState() => _ParentMilestoneState();
}

class _ParentMilestoneState extends State<ParentMilestonePage> {
  final MilestoneController milestoneController = MilestoneController();
  final SavingsController savingsController = SavingsController();
  final AccountController accountController = AccountController();
  String? userId = UserId().userId;
  String? childId = UserAccount().userAccount?.childId.toString();
  AccountModel? childAccount;

  late Future<List<MilestoneModel>> milestonesFuture;

  final poundsController = TextEditingController();
  final penceController = TextEditingController();

  Color titleColour = Helpers.getTitleColour();

  @override
  void initState() {
    super.initState();
    refreshMilestones();
    fetchChildAccount();
  }

  void refreshMilestones() {
    final childIdInt = childId != null ? int.tryParse(childId!) : null;
    if (childIdInt != null) {
      setState(() {
        milestonesFuture = milestoneController.getMilestonesForAccount(userId: childIdInt);
      });
    }
  }

  Future<void> fetchChildAccount() async {
    final childIdInt = childId != null ? int.tryParse(childId!) : null;
    print("Parsed childIdInt: $childIdInt");

    if (childIdInt != null) {
      print("Fetching child account for userId: $childIdInt");
      AccountModel? account = await accountController.getChildAccountForAccount(userId: childIdInt);
      setState(() {
        childAccount = account;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Helpers.getPageBackground(),
      body: FutureBuilder<List<MilestoneModel>>(
        future: milestonesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching milestones: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No milestones found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final milestones = snapshot.data!;

          // Separate active and completed milestones
          final activeMilestone = milestones.firstWhere(
                (m) => m.status.toLowerCase() == 'active',
          );

          final completedMilestones = milestones.where(
                (m) => m.status.toLowerCase() == 'completed',
          ).toList();

          // Save the active milestone for future use
          if (activeMilestone != null) {
            UserActiveMilestone().saveMilestone(activeMilestone);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Active Milestone
                  if (activeMilestone != null)
                    Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Active Milestone",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: titleColour,
                                ),
                              ),
                            ),
                          ),
                          // Active Milestone details
                          Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            elevation: 4,
                            color: Helpers.getMilestoneColor(activeMilestone.status),
                            child: ListTile(
                              title: Text(
                                activeMilestone.milestoneName,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID: ${activeMilestone.milestoneId ?? "No ID"}"),
                                  Text("Saved: £${activeMilestone.savedAmount.toStringAsFixed(2)}"),
                                  Text("Target: £${activeMilestone.targetAmount.toStringAsFixed(2)}"),
                                  Text("Status: ${activeMilestone.status}"),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _showAddSavingsDialog(context, userId!);
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
                          ),
                        ],
                      ),
                    ),
                  if (activeMilestone != null) SizedBox(height: 20),
                  // Completed Milestones List
                  if (completedMilestones.isNotEmpty)
                    Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Completed Milestones",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: titleColour,
                                ),
                              ),
                            ),
                          ),
                          // Completed Milestones list
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: completedMilestones.length,
                              itemBuilder: (context, index) {
                                final milestone = completedMilestones[index];

                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  elevation: 4,
                                  color: Helpers.getMilestoneColor(milestone.status),
                                  child: ListTile(
                                    title: Text(milestone.milestoneName, style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("ID: ${milestone.milestoneId ?? "No ID"}"),
                                        Text("Saved: £${milestone.savedAmount.toStringAsFixed(2)}"),
                                        Text("Target: £${milestone.targetAmount.toStringAsFixed(2)}"),
                                        Text("Status: ${milestone.status}"),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddSavingsDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        MilestoneModel? activeMilestone = UserActiveMilestone().getMilestone();


        return AlertDialog(
          title: Text('Add New Savings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Child ID'),
                  initialValue: childId,
                  enabled: false, // User ID should not be editable
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Milestone ID'),
                  initialValue: activeMilestone!.milestoneId.toString(),
                  enabled: false,
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

                final milestoneId = activeMilestone.milestoneId.toString();

                // Ensure pence is between 0 and 99
                if (pence < 0 || pence > 99) {
                  print("Pence must be between 0 and 99");
                  return;
                }

                // Calculate the amount to be added to the savings
                final amount = pounds + (pence / 100);

                print("Retrieved account: $childAccount");

                if (amount.toString().isNotEmpty && milestoneId.isNotEmpty) {
                  // Add the savings to the correct day of the week
                  int dayIndex = DateTime.now().weekday - 1; // Get the current day index (1 for Monday, 7 for Sunday)

                  // Create the savings entry in the database
                  final result = await savingsController.addSavings(
                      user: childAccount!,
                      amount: amount,
                      date: DateTime.now(),
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
                      Navigator.pop(context);
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create Savings!'),
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
