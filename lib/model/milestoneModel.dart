import 'package:savings_application/model/accountModel.dart';

class MilestoneModel {
  int milestoneId;
  AccountModel account;
  String milestoneName;
  double targetAmount;
  double savedAmount;
  DateTime startDate;
  DateTime? completionDate;
  String status;

  MilestoneModel({
    required this.milestoneId,
    required this.account,
    required this.milestoneName,
    required this.targetAmount,
    required this.savedAmount,
    required this.startDate,
    this.completionDate,
    required this.status,
  });

  // Convert JSON payload sent from the API
  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      milestoneId: json["milestoneId"] ?? 0, // default to 0 if null
      account: AccountModel.fromJson(json["user"]),
      milestoneName: json["milestoneName"],
      targetAmount: json["targetAmount"].toDouble(),
      savedAmount: json["savedAmount"].toDouble(),
      startDate: DateTime.parse(json["startDate"]),
      completionDate: json["completionDate"] != null ? DateTime.parse(json["completionDate"]) : null,
      status: json["status"],
    );
  }


  /// Convert from model to JSON object to send to the API
  Map<String, dynamic> toJson() => {
    "milestoneId": milestoneId,
    "user": account.toJson(),  // Convert AccountModel to JSON
    "milestoneName": milestoneName,
    "targetAmount": targetAmount,
    "savedAmount": savedAmount,
    "startDate": startDate.toIso8601String(),
    "completionDate": completionDate?.toIso8601String(),
    "status": status,
  };

  // Getter methods
  get getMilestoneId => milestoneId;
  get getAccount => account;
  get getMilestoneName => milestoneName;
  get getTargetAmount => targetAmount;
  get getSavedAmount => savedAmount;
  get getStartDate => startDate;
  get getCompletionDate => completionDate;
  get getStatus => status;
}
