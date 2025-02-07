import 'package:flutter/material.dart';
import 'package:savings_application/model/savingsModel.dart';
import 'week_savings.dart';

class WeekSavingsProvider extends ChangeNotifier {
  WeekSavings _weekSavings = WeekSavings();

  WeekSavings get weekSavings => _weekSavings;

  double getTotalSaved() {
    double total = 0;
    for (var day in _weekSavings.weekSavings) {
      total += day.savedAmount;
    }
    return total;
  }

  void addSavingsToDay(double amount, int dayIndex) {
    _weekSavings.addSavingsToDay(amount, dayIndex);
    notifyListeners();
  }

  void updateWeekSavings(List<SavingsModel> savings) {
    for (var saving in savings) {
      DateTime savingDate = saving.date;
      int dayIndex = (savingDate.weekday - 1) % 7;
      addSavingsToDay(saving.amount, dayIndex);
    }
  }
}
