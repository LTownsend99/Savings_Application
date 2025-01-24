import 'package:flutter/material.dart';
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/pages/child/child_transfer.dart';
import 'child_milestone.dart';

class ChildHomePage extends StatefulWidget {
  @override
  ChildHomePageState createState() => ChildHomePageState();
}

class ChildHomePageState extends State<ChildHomePage> {
  int _selectedIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    // Home Page
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Welcome to the Child Home Page!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
    // Child Milestone Page
    ChildMilestone(),
    // Transfer Page
    ChildTransfer(),
    // Settings Page
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 100, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'This is the Settings Page.',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  ];

  // List of titles for the AppBar
  final List<String> _titles = [
    'Home',
    'Child Milestone',
    'Transfer',
    'Settings',
  ];

  // Handler for navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Default.getPageBackground(),
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Use fixed type to ensure proper layout
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_friendly),
            label: 'Milestone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_pound),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.blue, // Color for selected items
        unselectedItemColor: Colors.grey, // Color for unselected items
        backgroundColor: Colors.white, // Set background color to white for contrast
        elevation: 10, // Optional: add elevation for better visual separation
      ),
    );
  }
}
