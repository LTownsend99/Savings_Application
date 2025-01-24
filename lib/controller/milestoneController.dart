import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:savings_application/model/milestoneModel.dart';

class MilestoneController{

  var url = "http://10.0.2.2:8080/milestone/";


  // Method to fetch savings balance by ID
  Future<MilestoneModel?> getSavedAmount({required int userId}) async {

    try {
      // Perform GET request
      final response = await http.get(Uri.parse("$url$userId"));

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
        final Map<String, dynamic> json = jsonDecode(response.body);
        return MilestoneModel.fromJson(json);

      } else if (response.statusCode == 404) {
        print("Milestone with ID $userId not found.");
      } else {
        print("Failed to fetch savings. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any errors during the request
      print("Error fetching milestone: $e");
    }

    return null; // Return null if the request fails
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

  Future<String?> addMilestone({
    required int userId,
    required String milestoneName,
    required double targetAmount,
    required DateTime startDate,
    required DateTime completionDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${url}create"),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(<String, dynamic>{
          "userId": userId.toString(),
          "milestoneName": milestoneName,
          "targetAmount": targetAmount.toString(),
          "startDate": startDate.toIso8601String(),
          "completionDate": completionDate.toIso8601String(),
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('milestoneId')) {
          return responseData['milestoneId'].toString(); // Return milestoneId on success
        } else {
          print("Error: 'milestoneId' not found in response");
          return null;
        }
      } else {
        print("Failed to add milestone. Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error adding milestone: $e");
      return null;
    }
  }


}