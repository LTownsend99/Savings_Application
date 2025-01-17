import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AccountController {
  var url = "http://10.0.2.2:8080/account/";

  Future<bool> createAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String passwordHash,
    required String role,
    required String childId,
    required DateTime dateOfBirth,
  }) async {
    try {
      // Simulate a network call with a delay
      final response = await http.post((Uri.parse(url + "create")),
          headers: <String, String>{"Content-Type": "application/json"},
          body: jsonEncode(<String, String>{
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "passwordHash": passwordHash,
            "role": role,
            "childId": childId,
            "dob": dateOfBirth.toIso8601String(),
          }));

      String responseString = response.body;

      //if (response.statusCode == 200) {}

      // Simulate success
      print("Account created for $firstName $lastName, Email: $email");
      return true;

      // For real implementation, you might call an API like:
      // final response = await http.post(Uri.parse('your-api-endpoint'), body: {...});
      // return response.statusCode == 200;
    } catch (e) {
      print("Error creating account: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${url}login"),
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          // Parse the JSON response
          final Map<String, dynamic> accountData = jsonDecode(response.body);
          print("Successfully logged in: ${response.body}");

          if (accountData != null && accountData.isNotEmpty) {
            return accountData;
          } else {
            print("Account data is empty or null");
            return null;
          }
        } catch (e) {
          print("Error parsing response: $e");
          return null;
        }
      } else if (response.statusCode == 403) {
        print("Invalid password");
        return null; // Invalid password
      } else {
        print("Failed to login. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error logging in: $e");
      return null;
    }
  }

}
