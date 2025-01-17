
import 'package:flutter/material.dart';

class ChildTransfer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.currency_pound, size: 100, color: Colors.green),
          SizedBox(height: 20),
          Text(
            'This is the Child Transfer Page.',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}