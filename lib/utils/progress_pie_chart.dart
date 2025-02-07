import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // Import the pie chart package
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/model/milestoneModel.dart';

class MilestoneProgressChart extends StatelessWidget {
  final MilestoneModel milestone;

  MilestoneProgressChart({required this.milestone});

  @override
  Widget build(BuildContext context) {
    double savedAmount = milestone.savedAmount;
    double targetAmount = milestone.targetAmount;
    String milestoneName = milestone.milestoneName;
    int milestoneId = milestone.milestoneId;

    // Calculate the progress (between 0.0 and 1.0)
    double progress = (savedAmount / targetAmount).clamp(0.0, 1.0);
    double remainingProgress = 1.0 - progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text("Milestone Id: $milestoneId ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,),),
            const SizedBox(width: 25),
            Text("Milestone Name: $milestoneName ",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),

        Text(
          "Total Saved: \£${savedAmount.toStringAsFixed(2)} / Goal: \£${targetAmount.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20), // Space between text and pie chart

        // Container with box styling around the Pie Chart
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the box
            borderRadius: BorderRadius.circular(10), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Light shadow for the box
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0), // Padding inside the box
          child: PieChart(
            dataMap: {
              "Progress": progress,
              "Remaining": remainingProgress,
            },
            colorList: [Colors.blue, Colors.grey],
            chartType: ChartType.ring, // Optionally, use a ring chart type
            ringStrokeWidth: 32, // The width of the ring
            animationDuration: Duration(milliseconds: 1500),
            chartValuesOptions: ChartValuesOptions(
              showChartValues: false, // Don't display numerical values
            ),
          ),
        ),
        const SizedBox(height: 10), // Space after the pie chart
      ],
    );
  }
}
