
class SavingsModel {
  int savId;
  int userId;
  double amount;
  DateTime date;
  int milestoneId;

  SavingsModel({
    required this.savId,
    required this.userId,
    required this.amount,
    required this.date,
    required this.milestoneId,
});

  ///Convert json payload sent from the API
  factory SavingsModel.fromJson(Map<String, dynamic> json) =>
      SavingsModel(
          savId: json["sav_id"],
          userId: json["user_id"],
          amount: json["amount"],
          date: json["date"],
          milestoneId: json["milestone_id"],
      );

  ///convert from model to json object to send to the API
  Map<String,dynamic> toJson() => {
    "savId": savId,
    "userId": userId,
    "amount": amount,
    "date": date,
    "milestoneId": milestoneId,
  };

  get getUserId => userId;
  get getSavId => savId;
  get getAmount => amount;
  get getDate => date;
  get getMilestoneId => milestoneId;


}