import 'package:flutter/material.dart';
import 'package:savings_application/model/milestoneModel.dart';

class MilestoneProgressBar extends StatelessWidget {
  final MilestoneModel milestone;

  MilestoneProgressBar({required this.milestone});

  @override
  Widget build(BuildContext context) {

    double savedAmount = milestone.savedAmount;
    double targetAmount = milestone.targetAmount;
    String milestoneName = milestone.milestoneName;
    int milestoneId = milestone.milestoneId;

    // Calculate the progress (between 0.0 and 1.0)
    double progress = (savedAmount / targetAmount).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress text
        Row(
          children: [
            Text("Milestone Id: $milestoneId ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)
            ),
            const SizedBox(width: 25,),
            Text("Milestone Name: $milestoneName ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)
            ),
          ],
        ),
        Text(
          "Total Saved: \£${savedAmount.toStringAsFixed(2)} / Goal: \£${targetAmount.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10), // Space between text and progress bar

        // LinearProgressIndicator (Progress Bar)
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300], // Background color
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Progress color
        ),
        const SizedBox(height: 10), // Space after the progress bar
      ],
    );
  }
}
