class DaySavings {
  final String dayOfWeek;
  final DateTime date;
  double savedAmount;

  DaySavings({
    required this.dayOfWeek,
    required this.date,
    this.savedAmount = 0.0,
  });

  // Method to add savings to a specific day
  void addSavings(double amount) {
    savedAmount += amount;
  }

  // Helper method to get the day of the week as a string
  static String getDayOfWeek(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return "Monday";
      case 1:
        return "Tuesday";
      case 2:
        return "Wednesday";
      case 3:
        return "Thursday";
      case 4:
        return "Friday";
      case 5:
        return "Saturday";
      case 6:
        return "Sunday";
      default:
        return "Unknown Day";
    }
  }
}
