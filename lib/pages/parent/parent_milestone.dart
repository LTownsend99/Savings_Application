import 'package:flutter/material.dart';
import 'package:savings_application/controller/milestoneController.dart';
import 'package:savings_application/helpers/helpers.dart';
import 'package:savings_application/model/milestoneModel.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_active_milestone.dart';
import 'package:savings_application/user/user_id.dart';

class ParentMilestonePage extends StatefulWidget {
  @override
  _ParentMilestoneState createState() => _ParentMilestoneState();
}

class _ParentMilestoneState extends State<ParentMilestonePage> {
  final MilestoneController controller = MilestoneController();
  String? userId = UserId().userId;
  String? childId = UserAccount().userAccount?.childId.toString();

  late Future<List<MilestoneModel>> milestonesFuture;

  @override
  void initState() {
    super.initState();
    refreshMilestones();
  }

  void refreshMilestones() {
    final childIdInt = childId != null ? int.tryParse(childId!) : null;
    if (childIdInt != null) {
      setState(() {
        milestonesFuture = controller.getMilestonesForAccount(userId: childIdInt);
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

          return SingleChildScrollView(  // Wrap the main body in SingleChildScrollView
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
                          // Title for Active Milestones within the box
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Active Milestone",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Helpers.getTitleColour(),
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
                          Padding(
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
                        ],
                      ),
                    ),
                  if (activeMilestone != null) SizedBox(height: 20),  // Space between active and completed lists

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
                          // Title for Completed Milestones within the box
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Completed Milestones",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Helpers.getTitleColour(),
                                ),
                              ),
                            ),
                          ),
                          // Completed Milestones list
                          SizedBox(
                            height: 300, // Adjust height for completed milestones list
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

}
