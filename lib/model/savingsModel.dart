
import 'package:savings_application/model/accountModel.dart';

class SavingsModel {
  int savId;
  AccountModel user;
  double amount;
  DateTime date;
  int milestoneId;

  SavingsModel({
    required this.savId,
    required this.user,
    required this.amount,
    required this.date,
    required this.milestoneId,
});

  ///Convert json payload sent from the API
  factory SavingsModel.fromJson(Map<String, dynamic> json) =>
      SavingsModel(
          savId: json["savingsId"] ?? 0,
          user: AccountModel.fromJson(json["user"]),
          amount: json["amount"],
          date: DateTime.parse(json["date"]),
          milestoneId: json["milestoneId"] ?? 0,
      );

  ///convert from model to json object to send to the API
  Map<String,dynamic> toJson() => {
    "savingsId": savId,
    "userId": user.toJson(),
    "amount": amount,
    "date": date,
    "milestoneId": milestoneId,
  };

  get getUserId => user;
  get getSavId => savId;
  get getAmount => amount;
  get getDate => date;
  get getMilestoneId => milestoneId;


}