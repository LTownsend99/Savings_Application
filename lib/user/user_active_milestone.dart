import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/milestoneModel.dart';
import 'package:savings_application/user/user_account.dart';

class UserActiveMilestone {
  // Singleton instance
  static final UserActiveMilestone _instance = UserActiveMilestone._internal();

  MilestoneModel? milestoneModel; // Store account data in memory

  AccountModel? account = UserAccount().getAccount();


  factory UserActiveMilestone() {
    return _instance;
  }

  UserActiveMilestone._internal();

  void saveMilestone(MilestoneModel milestone) {
    print("Saving milestone: ${milestone.milestoneName} ${milestone.status}"); // Debug print

    milestoneModel = milestone;
  }

  // Clear the account from memory
  void clearAccount() {
    milestoneModel = null;
  }

  MilestoneModel? getMilestone() {
    // Debug print
    print("Saving milestone: ${milestoneModel?.milestoneName} ${milestoneModel?.status}");

    // If milestoneModel is null, return a default MilestoneModel
    if (milestoneModel == null) {
      return MilestoneModel(
        milestoneId: 0, // default ID
        account: account!, // Assuming 'account' is available
        milestoneName: 'No Active Milestone', // placeholder name
        savedAmount: 0.0, // default saved amount
        targetAmount: 0.0, // default target amount
        status: 'inactive', // placeholder status
        startDate: DateTime.now(), // placeholder start date
      );
    }

    // Otherwise, return the existing milestoneModel
    return milestoneModel;
  }

}
