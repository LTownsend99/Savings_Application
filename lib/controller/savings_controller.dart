
import 'dart:convert';

import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/savingsModel.dart';
import 'package:http/http.dart' as http;


class SavingsController {
  var url = "http://10.0.2.2:8080/savings/"; //Backend Savings URL


  Future<SavingsModel?> getBalance({required int savingsId}) async {

    try {
      final response = await http.get(Uri.parse("${url}$savingsId"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return SavingsModel.fromJson(json);

      } else if (response.statusCode == 404) {
        print("Savings with ID $savingsId not found.");
      } else {
        print("Failed to fetch savings. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any errors during the request
      print("Error fetching savings: $e");
    }

    return null; // Return null if the request fails
  }

  Future<List<SavingsModel>> getSavingsForAccount({required int userId}) async {
    print("Received userId: $userId");

    try {
      final response = await http.get(Uri.parse("${url}user/$userId"));
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Log the decoded list to see the structure
        print("Decoded JSON List: $jsonList");

        return jsonList.map((json) => SavingsModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print("No Savings found for user ID $userId.");
      } else {
        print("Failed to fetch savings. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching savings: $e");
    }

    return []; // Return an empty list if the request fails
  }

  Future<bool> addSavings({
    required AccountModel user,
    required double amount,
    required DateTime date,
    required int milestoneId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${url}create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user": user.toJson(),
          "amount": amount,
          "date": date.toIso8601String(),
          "milestoneId": milestoneId,
        }),
      );

      if (response.statusCode == 201) {
        return true; // Successfully created
      } else {
        print("Failed to create savings. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return false; // Failure
      }
    } catch (e) {
      print("Error creating savings: $e");
      return false; // Error occurred
    }
  }
}
