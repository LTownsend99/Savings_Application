import 'package:savings_application/utils/day_savings.dart';

class WeekSavings {
  List<DaySavings> weekSavings = [];

  WeekSavings() {
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday; // 1 = Monday, 7 = Sunday

    // Get the start of this week's Monday
    DateTime startOfWeek = today.subtract(Duration(days: currentWeekday - 1));

    // Clear previous data (if it persists between app reloads)
    weekSavings.clear();

    for (int i = 0; i < 7; i++) {
      DateTime dateForDay = startOfWeek.add(Duration(days: i));

      print(
          "Initializing: ${DaySavings.getDayOfWeek(dateForDay.weekday - 1)} - ${dateForDay.toLocal()}");

      weekSavings.add(DaySavings(
        dayOfWeek: DaySavings.getDayOfWeek(dateForDay.weekday - 1),
        date: dateForDay,
      ));
    }
  }

  // Add savings to a specific day of the week
  void addSavingsToDay(double amount, int dayIndex) {
    if (dayIndex >= 0 && dayIndex < 7) {
      weekSavings[dayIndex]
          .addSavings(amount); // Update the savings for that day
    }
  }

  // Get the total saved amount for the week
  double getTotalSavingsForWeek() {
    double total = 0.0;
    for (var day in weekSavings) {
      total += day.savedAmount;
    }
    return total;
  }

  // Get the saved amount for a specific day
  double getSavedAmountForDay(int dayIndex) {
    if (dayIndex >= 0 && dayIndex < 7) {
      return weekSavings[dayIndex].savedAmount;
    }
    return 0.0;
  }

  // Get the current day's index (0 for Monday, 6 for Sunday)
  int getCurrentDayIndex() {
    return DateTime.now().weekday - 1; // 1 = Monday, 7 = Sunday
  }

  // Method to reset the weekly savings
  void resetWeekSavings() {
    for (int i = 0; i < 7; i++) {
      weekSavings[i].savedAmount = 0.0; // Reset each day's saved amount
    }
  }
}
