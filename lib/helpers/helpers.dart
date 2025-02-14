
import 'package:flutter/material.dart';

class Helpers {

  static Color getPageBackground() {
    return Colors.lightBlue.shade50;
  }

  static Color getTitleColour() {
    return Colors.green;
  }

  static Color getMilestoneColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.shade200;
      case 'active':
        return Colors.blue.shade200;
      default:
        return Colors.grey.shade300;
    }
  }
}