import 'package:savings_application/model/accountModel.dart';

class UserAccount {
  // Singleton instance
  static final UserAccount _instance = UserAccount._internal();

  AccountModel? userAccount; // Store account data in memory

  factory UserAccount() {
    return _instance;
  }

  UserAccount._internal();

  void saveAccount(AccountModel account) {
    print("Saving account: ${account.firstName} ${account.lastName}");
    userAccount = account;
  }

  // Clear the account from memory
  void clearAccount() {
    userAccount = null;
  }

  AccountModel? getAccount() {
    print("Retrieving account: ${userAccount?.firstName} ${userAccount?.lastName}");
    return userAccount;
  }
}
