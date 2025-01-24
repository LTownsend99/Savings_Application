
import 'dart:convert';

import 'package:savings_application/model/savingsModel.dart';
import 'package:http/http.dart' as http;


class SavingsController {
  var url = "http://10.0.2.2:8080/savings/";


  // Method to fetch savings balance by ID
  Future<SavingsModel?> getBalance({required int savingsId}) async {

    try {
      // Perform GET request
      final response = await http.get(Uri.parse("${url}$savingsId"));

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response
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
}
