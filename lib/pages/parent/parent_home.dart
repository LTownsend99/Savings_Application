import 'package:flutter/material.dart';
import 'package:savings_application/controller/account_controller.dart';
import 'package:savings_application/helpers/helpers.dart';
import 'package:savings_application/model/accountModel.dart';
import 'package:savings_application/model/milestoneModel.dart';
import 'package:savings_application/pages/parent/parent_milestone.dart';
import 'package:savings_application/pages/more.dart';
import 'package:savings_application/user/user_account.dart';
import 'package:savings_application/user/user_active_milestone.dart';
import 'package:savings_application/user/user_id.dart';
import 'package:savings_application/utils/parent_savings_tips.dart';
import 'package:savings_application/utils/progress_pie_chart.dart';

class ParentHomePage extends StatefulWidget {
  @override
  ParentHomePageState createState() => ParentHomePageState();
}

class ParentHomePageState extends State<ParentHomePage> {
  int _selectedIndex = 0;
  String? userId = UserId().userId;
  String? childId = UserAccount().userAccount?.childId.toString();
  Color titleColour = Helpers.getTitleColour();

  AccountController accountController = AccountController();
  AccountModel? childAccount;
  MilestoneModel? activeMilestone;


  // List of titles for the AppBar
  final List<String> _titles = [
    'Home',
    'Milestone',
    'More',
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
    fetchChildAccount();
    fetchActiveMilestone();
  }

  Future<void> fetchActiveMilestone() async {
    activeMilestone = await UserActiveMilestone().getMilestone();
    setState(() {});
  }


  Future<void> fetchChildAccount() async {
    final childIdInt = childId != null ? int.tryParse(childId!) : null;
    print("Parsed childIdInt: $childIdInt");

    if (childIdInt != null) {
      print("Fetching child account for userId: $childIdInt");
      AccountModel? account = await accountController.getChildAccountForAccount(userId: childIdInt);
      setState(() {
        childAccount = account;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    MilestoneModel? activeMilestone = UserActiveMilestone().getMilestone();


    // List of pages for navigation
    final List<Widget> _pages = [
      SingleChildScrollView(
        child: Column(
          children: [
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
                      "Child Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: titleColour,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (childAccount != null)
                      ListTile(
                        title: Text(
                          "${childAccount!.firstName} ${childAccount!.lastName}",
                          style: TextStyle(color:  titleColour,),
                        ),
                        subtitle: Text(
                          "User ID: ${childAccount!.userId}\nDOB: ${childAccount!.dateOfBirth?.toLocal().toString().split(' ')[0] ?? 'N/A'}",
                          style: TextStyle(color:  titleColour,),
                        ),
                      )
                    else
                      Text(
                        "No child account found",
                        style: TextStyle(color:  titleColour,),
                      ),
                  ],
                ),
              ),
            ),
            ParentSavingsTipsBox(),

            MilestoneProgressChart(milestone: activeMilestone!),

          ],
        ),
      ),
      ParentMilestonePage(),
      MorePage(),
    ];


    return Scaffold(
      backgroundColor: Helpers.getPageBackground(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
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
