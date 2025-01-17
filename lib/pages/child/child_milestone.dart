import 'package:flutter/material.dart';

class ChildMilestone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.child_friendly, size: 100, color: Colors.green),
          SizedBox(height: 20),
          Text(
            'This is the Child Milestone Page.',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
