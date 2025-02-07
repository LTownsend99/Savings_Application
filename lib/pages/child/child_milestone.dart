import 'package:flutter/material.dart';
import 'package:savings_application/controller/milestoneController.dart';
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/milestoneModel.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_id.dart';
import 'package:savings_application/utils/saved_amount_provider.dart';

class ChildMilestone extends StatefulWidget {
  @override
  _ChildMilestoneState createState() => _ChildMilestoneState();
}

class _ChildMilestoneState extends State<ChildMilestone> {
  final MilestoneController controller = MilestoneController();
  String? userId = UserId().userId;

  // Track the total saved amount
  double totalSavedAmount = 0.0;

  final milestoneNameController = TextEditingController();
  final targetAmountController = TextEditingController();
  final completionDateController = TextEditingController();
  final poundsController = TextEditingController();
  final penceController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime? completionDate;

  late Future<List<MilestoneModel>> milestonesFuture;

  @override
  void initState() {
    super.initState();
    // Initialize milestonesFuture in initState
    refreshMilestones(); // Fetch the milestones on initial load
  }

  // Method to fetch milestones and calculate the total saved amount
  void refreshMilestones() {
    final userIdInt = userId != null ? int.tryParse(userId!) : null;
    if (userIdInt != null) {
      setState(() {
        milestonesFuture = controller.getMilestonesForAccount(userId: userIdInt);

        // After fetching the milestones, calculate the total saved amount
        milestonesFuture.then((milestones) {

          //Reset total and recalculate totalSavedAmount each time they are refreshed
          totalSavedAmount = 0.0;

          totalSavedAmount = milestones.fold(0.0, (sum, milestone) {
            return sum + (milestone.savedAmount ?? 0.0); // Sum the saved amounts
          });

          SavedAmountProvider.resetTotalSavedAmount();
          SavedAmountProvider.updateSavedAmount(totalSavedAmount); // Update global value

        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Default.getPageBackground(),
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
                height: 450,
                child: ListView.builder(
                  itemCount: milestones.length,
                  itemBuilder: (context, index) {
                    final milestone = milestones[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4,
                      color: Colors.green.shade50,
                      child: ListTile(
                        title: Text(milestone.milestoneName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID: ${milestone.milestoneId ?? "No ID"}"),
                            Text("Saved: £${milestone.savedAmount.toStringAsFixed(2)}"),
                            Text("Target: £${milestone.targetAmount.toStringAsFixed(2)}"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMilestoneDialog(context, userId!);
        },
        child: Icon(Icons.add),
        backgroundColor: Default.getTitleColour(),
        foregroundColor: Colors.white,
        tooltip: 'Add New Milestone',
      ),
    );
  }

  void _showAddMilestoneDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Milestone'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'User ID'),
                  initialValue: userId,
                  enabled: false, // User ID should not be editable
                ),
                TextField(
                  controller: milestoneNameController,
                  decoration: InputDecoration(labelText: 'Milestone Name'),
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
                        maxLength: 2,
                        decoration: InputDecoration(labelText: 'Pence', counterText: ''),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Start Date'),
                  initialValue: "${_startDate.toLocal()}".split(' ')[0],
                  enabled: false, // Start date should not be editable
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
                final milestoneName = milestoneNameController.text;
                final pounds = int.tryParse(poundsController.text) ?? 0;
                final pence = int.tryParse(penceController.text) ?? 0;

                // Ensure pence is between 0 and 99
                if (pence < 0 || pence > 99) {
                  print("Pence must be between 0 and 99");
                  return;
                }

                // Calculate the targetAmount
                final targetAmount = pounds + (pence / 100);

                AccountModel? account = UserAccount().getAccount();
                print("Retrieved account: $account");

                if (milestoneName.isNotEmpty) {
                  final result = await controller.addMilestone(
                    user: account!,
                    milestoneName: milestoneName,
                    targetAmount: targetAmount,
                    startDate: _startDate,
                  );

                  if (result) {
                    Navigator.pop(context); // Close dialog on success

                    setState(() {
                      // Trigger a refresh of the milestone list
                      refreshMilestones();
                    });
                  } else {
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
