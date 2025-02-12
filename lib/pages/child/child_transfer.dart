import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Import Provider package
import 'package:savings_application/controller/savings_controller.dart';
import 'package:savings_application/controller/milestoneController.dart';
import 'package:savings_application/helpers/date_time_helper.dart';
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/milestoneModel.dart';
import 'package:savings_application/model/savingsModel.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_active_milestone.dart';
import 'package:savings_application/user/user_id.dart';
import 'package:savings_application/utils/saved_amount_provider.dart';
import 'package:savings_application/utils/week_savings_provider.dart';  // Import WeekSavingsProvider

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
  final referenceController = TextEditingController();
  final poundsControllerMoneyOut = TextEditingController();
  final penceControllerMoneyOut = TextEditingController();


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
    // Access the WeekSavingsProvider using Provider.of
    WeekSavingsProvider weekSavingsProvider = Provider.of<WeekSavingsProvider>(context);

    return Scaffold(
      backgroundColor: Default.getPageBackground(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              "Total Saved: £${SavedAmountProvider.totalSavedAmount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddSavingsDialog(context, userId!, weekSavingsProvider);
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showMoneyOutDialog(context, userId!, weekSavingsProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(300, 50),
              ),
              child: Text("Money Out",
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

                // Calculate total savings for all time
                double totalSavedAmount = savings.fold(0.0, (sum, item) => sum + item.amount);

                // Update the global saved amount
                SavedAmountProvider.updateSavedAmount(totalSavedAmount);


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

  void _showAddSavingsDialog(BuildContext context, String userId, WeekSavingsProvider weekSavingsProvider) {
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
                  decoration: InputDecoration(labelText: 'User ID'),
                  initialValue: userId,
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

                AccountModel? account = UserAccount().getAccount();
                print("Retrieved account: $account");

                if (amount.toString().isNotEmpty && milestoneId.isNotEmpty) {
                  // Add the savings to the correct day of the week
                  int dayIndex = DateTime.now().weekday - 1; // Get the current day index (1 for Monday, 7 for Sunday)

                  setState(() {
                    // Update the savings for the current day
                    weekSavingsProvider.addSavingsToDay(amount, dayIndex);
                  });

                  // Now update the global saved amount
                  SavedAmountProvider.updateSavedAmount(amount);

                  // Create the savings entry in the database
                  final result = await savingsController.addSavings(
                      user: account!,
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

  void _showMoneyOutDialog(BuildContext context, String userId, WeekSavingsProvider weekSavingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        MilestoneModel? activeMilestone = UserActiveMilestone().getMilestone();

        return AlertDialog(
          title: Text('Transfer Money Out'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'User ID'),
                  initialValue: userId,
                  enabled: false, // User ID should not be editable
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send to', // Title
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5), // Space between title and text box
                    Container(
                      width: double.infinity, // Makes the box expand to full width
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Mimics TextFormField background
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey), // Mimics TextFormField border
                      ),
                      child: Text(
                        'Where account details would be filled in. However, for this project, this is out of scope.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: poundsControllerMoneyOut,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Pounds (£)'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: penceControllerMoneyOut,
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
                  decoration: InputDecoration(labelText: 'Reference'),
                  controller: referenceController,
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
                final pounds = int.tryParse(poundsControllerMoneyOut.text) ?? 0;
                final pence = int.tryParse(penceControllerMoneyOut.text) ?? 0;

                final reference = referenceController.text;


                // Ensure pence is between 0 and 99
                if (pence < 0 || pence > 99) {
                  print("Pence must be between 0 and 99");
                  return;
                }

                // Calculate the amount to be added to the savings
                final transferOutAmount = pounds + (pence / 100);

                if (transferOutAmount.toString().isNotEmpty && reference.isNotEmpty) {

                  final newSavedAmount = SavedAmountProvider.totalSavedAmount - transferOutAmount;
                  print(newSavedAmount);

                  // Now update the global saved amount
                  SavedAmountProvider.updateSavedAmount(newSavedAmount);

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
