import 'package:flutter/material.dart';
import 'package:savings_application/controller/savings_controller.dart';
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/model/savingsModel.dart';
import 'package:savings_application/pages/child/child_transfer.dart';
import 'package:savings_application/user/user_id.dart';
import 'child_milestone.dart';
import 'package:savings_application/utils/progress_bar.dart';

class ChildHomePage extends StatefulWidget {
  @override
  ChildHomePageState createState() => ChildHomePageState();
}

class ChildHomePageState extends State<ChildHomePage> {
  SavingsController savingsController = SavingsController();

  int _selectedIndex = 0;
  String? userId = UserId()
      .userId; // Keep this as it is, assuming it's part of user session management.
  double balance =
      0.00; // Initial balance, this can be updated based on real data later.
  late double totalSaved;
  double targetAmount = 300;
  late double progress;

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

  // Fetch balance from the database
  Future<void> fetchBalance() async {
    try {
      final SavingsModel? savings = await savingsController.getBalance(savingsId: 1); // Replace 1 with the correct savingsId

      if (savings != null) {
        setState(() {
          balance = savings.amount; // Update the balance using the fetched amount
        });
      }
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    totalSaved = balance;
    progress = (totalSaved/targetAmount).clamp(0.0, 1.0);

    final List<Widget> _pages = [
      // Home Page (Balance Display)
      SingleChildScrollView(
        child: Column(
          children: [
            // Centralized Balance section at the top
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Balance Title
                    Text(
                      "Balance",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing between title and balance

                    // Balance Value
                    Text(
                      "\£${balance.toStringAsFixed(2)}", // Format balance to 2 decimal places
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Default.getTitleColour(), // Highlight balance in green
                      ),
                    ),
                    const SizedBox(height: 30), // Extra space below balance
                  ],
                ),
              ),
            ),

            // Container for the list of saved amounts over the last week
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Week Saved Amounts Title
                    Text(
                      "Saved Amounts (Last 7 Days)",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Default.getTitleColour(),
                      ),
                    ),
                    const SizedBox(height: 10), // Space between title and list

                    // Scrollable list of saved amounts for the last week
                    SizedBox(
                      height: 300, // Set height to make the list scrollable
                      child: ListView.builder(
                        itemCount: 7, // Display 7 items (one for each day of the week)
                        itemBuilder: (context, index) {
                          // Sample data for each day's saved amount
                          double savedAmount = 50.0 * (index + 1); // Just an example

                          return ListTile(
                            title: Text("Day ${index + 1}"),
                            subtitle: Text("\$${savedAmount.toStringAsFixed(2)}"),
                            trailing: Icon(Icons.arrow_forward_ios, size: 18),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0,3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Milestone Progress Title
                    Text(
                      "Milestone Progress",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Default.getTitleColour(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    //Progress Bar
                    MilestoneProgressBar(totalSaved: totalSaved, targetAmount: targetAmount),




                  ],
                ),
              ),
            )
          ],
        ),
      )
,
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
        type: BottomNavigationBarType.fixed,
        // Use fixed type to ensure proper layout
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
        selectedItemColor: Colors.blue,
        // Color for selected items
        unselectedItemColor: Colors.grey,
        // Color for unselected items
        backgroundColor: Colors.white,
        // Set background color to white for contrast
        elevation: 10, // Optional: add elevation for better visual separation
      ),
    );
  }
}
