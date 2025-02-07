import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savings_application/pages/login.dart';
import 'package:savings_application/utils/week_savings_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WeekSavingsProvider(),
    child: MyApp(),
  ),);
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
