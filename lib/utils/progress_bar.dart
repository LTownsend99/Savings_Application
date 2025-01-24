import 'package:flutter/material.dart';

class MilestoneProgressBar extends StatelessWidget {
  final double totalSaved;
  final double targetAmount;

  MilestoneProgressBar({required this.totalSaved, required this.targetAmount});

  @override
  Widget build(BuildContext context) {
    // Calculate the progress (between 0.0 and 1.0)
    double progress = (totalSaved / targetAmount).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress text
        Text(
          "Total Saved: \£${totalSaved.toStringAsFixed(2)} / Goal: \£${targetAmount.toStringAsFixed(2)}",
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
