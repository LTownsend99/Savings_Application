import 'package:flutter/material.dart';
import 'package:savings_application/controller/milestoneController.dart';
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/model/milestoneModel.dart';
import 'package:savings_application/user/user_id.dart';

class ChildMilestone extends StatelessWidget {
  final MilestoneController controller = MilestoneController();
  String? userId = UserId().userId;

  final milestoneNameController = TextEditingController();
  final targetAmountController = TextEditingController();
  final completionDateController = TextEditingController();
  final poundsController = TextEditingController();
  final penceController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime? completionDate;

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != completionDate) {
      completionDate = picked;
      completionDateController.text =
      "${completionDate!.year}-${completionDate!.month.toString().padLeft(2, '0')}-${completionDate!.day.toString().padLeft(2, '0')}"; // Update the text field
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MilestoneModel>?>(
        future: controller.getMilestonesByStatus(
          "active", // Ensure userId is parsed as int
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error fetching milestones: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No milestones found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Data is available, build the scrollable list
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
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Saved', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Target', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: milestones.map((milestone) {
                    return DataRow(cells: [
                      DataCell(Text(milestone.milestoneId.toString())),
                      DataCell(Text(milestone.milestoneName)),
                      DataCell(Text("\$${milestone.savedAmount.toStringAsFixed(2)}")),
                      DataCell(Text("\$${milestone.targetAmount.toStringAsFixed(2)}")),
                    ]);
                  }).toList(),
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
        tooltip: 'Add New Milestone',
      ),
    );
  }

  void _showAddMilestoneDialog(BuildContext context, String userId) {
    final poundsController = TextEditingController();
    final penceController = TextEditingController();

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
                        maxLength: 2, // Limit to 2 digits
                        decoration: InputDecoration(
                          labelText: 'Pence',
                          counterText: '', // Hides the character count
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Start Date'),
                  initialValue: "${_startDate.toLocal()}".split(' ')[0],
                  enabled: false, // Start date should not be editable
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        // Prevent manual input
                        decoration: const InputDecoration(
                          labelText: "Completion Date",
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: completionDateController,
                        onTap: () => selectDate(context),
                        // Show DatePicker on tap
                        validator: (value) {
                          if (completionDate == null) {
                            return "Completion Date is required";
                          }
                          return null;
                        },
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
                final milestoneName = milestoneNameController.text;
                // Parse pounds and pence values
                final pounds = int.tryParse(poundsController.text) ?? 0;
                final pence = int.tryParse(penceController.text) ?? 0;

                // Ensure pence is between 0 and 99
                if (pence < 0 || pence > 99) {
                  print("Pence must be between 0 and 99");
                  return;
                }

                // Calculate the targetAmount
                final targetAmount = pounds + (pence / 100);

                if (milestoneName.isNotEmpty && targetAmount != null && completionDate != null) {
                  // Call your controller to add the milestone
                  final result = controller.addMilestone(
                    userId: int.parse(userId),
                    milestoneName: milestoneName,
                    targetAmount: targetAmount,
                    startDate: _startDate,
                    completionDate: completionDate!,
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
