import 'package:savings_application/model/accountModel.dart';

class UserAccount {
  // Singleton instance
  static final UserAccount _instance = UserAccount._internal();

  AccountModel? userAccount; // Store account data in memory

  factory UserAccount() {
    return _instance;
  }

  UserAccount._internal();

  // Save account to memory
  void saveAccount(AccountModel account) {
    userAccount = account;
  }

  // Clear the account from memory
  void clearAccount() {
    userAccount = null;
  }

  // Retrieve the account
  AccountModel? getAccount() {
    return userAccount;
  }
}
