import 'package:savings_application/model/accountModel.dart';

class MilestoneModel{

  int milestoneId;
  AccountModel account;
  String milestoneName;
  double targetAmount;
  double savedAmount;
  DateTime startDate;
  DateTime completionDate;
  String status;

  MilestoneModel({
    required this.milestoneId,
    required this.account,
    required this.milestoneName,
    required this.targetAmount,
    required this.savedAmount,
    required this.startDate,
    required this.completionDate,
    required this.status,
});


  ///Convert json payload sent from the API
  factory MilestoneModel.fromJson(Map<String, dynamic> json) =>
      MilestoneModel(
        milestoneId: json["milestone_id"],
        account: AccountModel.fromJson(json["user"]), // Fix here
        milestoneName: json["milestone_name"],
        targetAmount: json["target_amount"].toDouble(), // Ensure double conversion
        savedAmount: json["saved_amount"].toDouble(),   // Ensure double conversion
        startDate: DateTime.parse(json["start_date"]), // Parse DateTime
        completionDate: DateTime.parse(json["completion_date"]), // Parse DateTime
        status: json["status"],
      );


  ///convert from model to json object to send to the API
  Map<String,dynamic> toJson() => {
    "milestoneId": milestoneId,
    "account": account,
    "milestoneName": milestoneName,
    "targetAmount": targetAmount,
    "savedAmount": savedAmount,
    "startDate": startDate,
    "completionDate": completionDate,
    "status": status
  };

  get getMilestoneId => milestoneId;
  get getAccount => account;
  get getMilestoneName => milestoneName;
  get getTargetAmount => targetAmount;
  get getSavedAmount => savedAmount;
  get getStartDate => startDate;
  get getCompletionDate => completionDate;
  get getStatus => status;

}