import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savings_application/controller/savings_controller.dart';
import 'package:savings_application/helpers/default.dart';
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/milestoneModel.dart';
import 'package:savings_application/model/savingsModel.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_active_milestone.dart';
import 'package:savings_application/user/user_id.dart';
import 'package:savings_application/utils/saved_amount_provider.dart';
import 'package:savings_application/utils/week_savings_provider.dart';  // Import the WeekSavingsProvider
import 'package:savings_application/utils/progress_bar.dart';
import 'child_milestone.dart';
import 'child_transfer.dart';

class ChildHomePage extends StatefulWidget {
  @override
  ChildHomePageState createState() => ChildHomePageState();
}

class ChildHomePageState extends State<ChildHomePage> {
  SavingsController savingsController = SavingsController();
  String? userId = UserId().userId;

  int _selectedIndex = 0;
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

  @override
  void initState() {
    super.initState();
    updateWeeklySavings(); // Update weekly savings when the page is loaded
  }

  // Method to update weekly savings on page load
  void updateWeeklySavings() async {
    final userIdInt = userId != null ? int.tryParse(userId!) : null;

    if (userIdInt != null) {
      // Fetch savings for the last 7 days from the database or API
      List<SavingsModel> savings = await savingsController.getSavingsForAccount(userId: userIdInt);

      final weekSavingsProvider = Provider.of<WeekSavingsProvider>(context, listen: false);
      weekSavingsProvider.weekSavings.resetWeekSavings();

      weekSavingsProvider.updateWeekSavings(savings);  // Update the week savings

      // Debugging: Print the savings for each day after it is updated
      print("Updated Week Savings: ");
      for (int i = 0; i < 7; i++) {
        print("${weekSavingsProvider.weekSavings.weekSavings[i].dayOfWeek}: £${weekSavingsProvider.weekSavings.weekSavings[i].savedAmount.toStringAsFixed(2)}");
      }

      setState(() {
        totalSaved = SavedAmountProvider.totalSavedAmount;
        progress = (totalSaved / targetAmount).clamp(0.0, 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekSavingsProvider = Provider.of<WeekSavingsProvider>(context);

    MilestoneModel? activeMilestone = UserActiveMilestone().getMilestone();


    totalSaved = SavedAmountProvider.totalSavedAmount;
    progress = (totalSaved / targetAmount).clamp(0.0, 1.0);

    final List<Widget> _pages = [
      // Home Page
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
                      "Total Saved",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing between title and balance

                    // Balance Value
                    Text(
                      "£${totalSaved.toStringAsFixed(2)}", // Format balance to 2 decimal places
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: Default.getTitleColour(),
                      ),
                    ),
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
                          double savedAmount = weekSavingsProvider.weekSavings.weekSavings[index].savedAmount;

                          String dayLabel = '${weekSavingsProvider.weekSavings.weekSavings[index].dayOfWeek} '
                              '(${weekSavingsProvider.weekSavings.weekSavings[index].date.toLocal().toString().split(' ')[0]})';

                          return ListTile(
                            title: Text(dayLabel), // Display the day and date
                            trailing: Text("Saved: £${savedAmount.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 14),), // Display the saved amount for that day
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Milestone Progress Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Milestone Progress",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Default.getTitleColour(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Progress Bar
                    MilestoneProgressBar(milestone: activeMilestone!,),
                  ],
                ),
              ),
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
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}
