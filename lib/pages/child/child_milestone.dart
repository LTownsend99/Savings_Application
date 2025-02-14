import 'package:flutter/material.dart';
import 'package:savings_application/controller/milestoneController.dart';
import 'package:savings_application/helpers/helpers.dart';
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/milestoneModel.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_active_milestone.dart';
import 'package:savings_application/user/user_id.dart';
import 'package:savings_application/utils/progress_pie_chart.dart';
import 'package:savings_application/utils/saved_amount_provider.dart';

class ChildMilestone extends StatefulWidget {
  @override
  _ChildMilestoneState createState() => _ChildMilestoneState();
}

class _ChildMilestoneState extends State<ChildMilestone> {
  final MilestoneController controller = MilestoneController();
  String? userId = UserId().userId;

  double totalSavedAmount = 0.0;

  final milestoneNameController = TextEditingController();
  final poundsController = TextEditingController();
  final penceController = TextEditingController();

  DateTime _startDate = DateTime.now();

  late Future<List<MilestoneModel>> milestonesFuture;

  late MilestoneModel firstActiveMilestone;

  @override
  void initState() {
    super.initState();
    refreshMilestones();
  }

  void refreshMilestones() {
    final userIdInt = userId != null ? int.tryParse(userId!) : null;
    if (userIdInt != null) {
      setState(() {
        milestonesFuture = controller.getMilestonesForAccount(userId: userIdInt);

        milestonesFuture.then((milestones) {
          totalSavedAmount = milestones.fold(0.0, (sum, milestone) {
            return sum + (milestone.savedAmount ?? 0.0);
          });

          SavedAmountProvider.resetTotalSavedAmount();
          SavedAmountProvider.updateSavedAmount(totalSavedAmount);

          if(milestones.any((m) => m.status.toLowerCase() == 'active'))
          {
            firstActiveMilestone = milestones.firstWhere(
                  (m) => m.status.toLowerCase() == 'active',
            );

            print('first active: $firstActiveMilestone');

            UserActiveMilestone().saveMilestone(firstActiveMilestone);
          }else
          {
            UserActiveMilestone().clearAccount();
          }

          setState(() {});

        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MilestoneModel? activeMilestone = UserActiveMilestone().getMilestone();

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

          //  Sort milestones: Active first, then Completed
          milestones.sort((a, b) {
            if (a.status.toLowerCase() == 'active' && b.status.toLowerCase() != 'active') {
              return -1; // "Active" comes first
            } else if (a.status.toLowerCase() != 'active' && b.status.toLowerCase() == 'active') {
              return 1; // "Completed" comes later
            }
            return 0; // Maintain original order otherwise
          });
          
          if(milestones.any((m) => m.status.toLowerCase() == 'active'))
            {
              firstActiveMilestone = milestones.firstWhere(
                    (m) => m.status.toLowerCase() == 'active',
              );

              print('first active: $firstActiveMilestone');

              UserActiveMilestone().saveMilestone(firstActiveMilestone);
            }else
              {
                UserActiveMilestone().clearAccount();
              }

          return SingleChildScrollView(  // Wrap the main body in SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Milestone list
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
                    child: SizedBox(
                      height: 450,
                      child: ListView.builder(
                        itemCount: milestones.length,
                        itemBuilder: (context, index) {
                          final milestone = milestones[index];

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
                  ),
                  // Add the PieChart below the milestones list
                  MilestoneProgressChart(milestone: activeMilestone!),
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
        backgroundColor: Helpers.getTitleColour(),
        foregroundColor: Colors.white,
        tooltip: 'Add New Milestone',
        child: Icon(Icons.add),
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
                  enabled: false,
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
                  enabled: false,
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
                // Check if an active milestone exists before saving
                MilestoneModel? activeMilestone = UserActiveMilestone().getMilestone();

                if (activeMilestone != null && activeMilestone.status.toLowerCase() == 'active') {
                  // Show message and prevent saving
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'You already have an active milestone. Please complete it first.',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                  return; // Exit function, prevent milestone creation
                }

                // If no active milestone, proceed with saving
                final milestoneName = milestoneNameController.text;
                final pounds = int.tryParse(poundsController.text) ?? 0;
                final pence = int.tryParse(penceController.text) ?? 0;

                if (pence < 0 || pence > 99) {
                  print("Pence must be between 0 and 99");
                  return;
                }

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
                    Navigator.pop(context);
                    setState(() {
                      refreshMilestones();
                    });
                  } else {
                    if(mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to create milestone!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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
