class SavedAmountProvider {
  static double totalSavedAmount = 0.0;

  static void updateSavedAmount(double amount) {
    totalSavedAmount = amount;
  }

  static void resetTotalSavedAmount() {
    totalSavedAmount = 0.0;
  }
}