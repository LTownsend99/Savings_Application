import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/milestoneModel.dart';

class MilestoneController{

  var url = "http://10.0.2.2:8080/milestone/";


  Future<List<MilestoneModel>> getMilestonesForAccount({required int userId}) async {
    print("Received userId: $userId"); // Log the userId to check if it's really being passed correctly

    try {
      final response = await http.get(Uri.parse("${url}user/$userId"));
      print("Response status: ${response.statusCode}");  // Log status code
      print("Response body: ${response.body}"); // Log the response body

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Log the decoded list to see the structure
        print("Decoded JSON List: $jsonList");

        return jsonList.map((json) => MilestoneModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print("No milestones found for user ID $userId.");
      } else {
        print("Failed to fetch milestones. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching milestones: $e");
    }

    return []; // Return an empty list if the request fails
  }


  // Method to fetch milestones for a user by userId
  Future<List<MilestoneModel>?> getMilestonesByStatus(String status) async {
    try {
      final response = await http.get(Uri.parse("${url}milestone/status/$status"));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => MilestoneModel.fromJson(json)).toList();
      } else {
        print("No milestones found with status: $status.");
      }
    } catch (e) {
      print("Error fetching milestones: $e");
    }
    return null; // Return null if no milestones are found
  }

  Future<MilestoneModel?> getActiveMilestoneForUser(String userId) async {
    final milestones = await getMilestonesByStatus("active");
    // Add any additional user-based filtering if needed
    return milestones?.isNotEmpty == true ? milestones?.first : null;
  }

  Future<bool> addMilestone({
    required AccountModel user,
    required String milestoneName,
    required double targetAmount,
    required DateTime startDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${url}create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user": user.toJson(),
          "milestoneName": milestoneName,
          "startAmount": 0.0,
          "targetAmount": targetAmount,
          "startDate": startDate.toIso8601String(),
          "completionDate": null,
          "status": "active",
        }),
      );

      if (response.statusCode == 201) {
        return true; // Successfully created
      } else {
        print("Failed to create milestone. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}"); // Print the response body
        return false; // Failure
      }
    } catch (e) {
      print("Error creating milestone: $e");
      return false; // Error occurred
    }
  }



}