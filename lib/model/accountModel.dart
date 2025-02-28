import 'dart:convert';

AccountModel accountModelJson(String str) =>
    AccountModel.fromJson(json.decode(str));

/// Convert model to JSON
String accountModelToJson(AccountModel data) => json.encode(data.toJson());

class AccountModel {
  int userId;
  String firstName;
  String lastName;
  String email;
  String passwordHash;
  String role;
  int? childId; // Nullable as a child account does not need one
  DateTime? dateOfBirth;

  AccountModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.passwordHash,
    required this.role,
    this.childId,
    this.dateOfBirth,
  });

  // Convert JSON payload sent from the API
  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    userId: json["userId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    passwordHash: json["passwordHash"],
    role: json["role"],
    childId: json["childId"] != null ? json["childId"] : null,
    dateOfBirth: json["dob"] != null ? DateTime.parse(json["dob"]) : null,
  );


  /// Convert from model to JSON object to send to the API
  Map<String, dynamic> toJson() => {
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "passwordHash": passwordHash,
    "role": role,
    "childId": childId,
    "dob": dateOfBirth?.toIso8601String(),
  };

  get getUserId => userId;
  get getFirstName => firstName;
  get getLastName => lastName;
  get getEmail => email;
  get getPassword => passwordHash;
  get getRole => role;
  get getChildId => childId;
  get getDateOfBirth => dateOfBirth;
}
