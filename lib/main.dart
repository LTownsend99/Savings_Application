import 'package:flutter/material.dart';
import 'package:savings_application/pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Savings_App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(), // Set HomePage as the home
    );
  }
}
