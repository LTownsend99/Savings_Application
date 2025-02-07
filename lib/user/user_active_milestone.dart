import 'package:savings_application/model/milestoneModel.dart';

class UserActiveMilestone {
  // Singleton instance
  static final UserActiveMilestone _instance = UserActiveMilestone._internal();

  MilestoneModel? milestoneModel; // Store account data in memory

  factory UserActiveMilestone() {
    return _instance;
  }

  UserActiveMilestone._internal();

  void saveAccount(MilestoneModel milestone) {
    print("Saving milestone: ${milestone.milestoneName} ${milestone.status}"); // Debug print

    milestoneModel = milestone;
  }

  // Clear the account from memory
  void clearAccount() {
    milestoneModel = null;
  }

  MilestoneModel? getMilestone() {
    print("Saving milestone: ${milestoneModel?.milestoneName} ${milestoneModel?.status}"); // Debug print
    return milestoneModel;
  }
}
