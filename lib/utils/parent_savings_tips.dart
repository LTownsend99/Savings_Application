import 'package:flutter/material.dart';

class ParentSavingsTips{

  static final List<String> savingTips = [
    "Offer your children money for doing chores around the house.",
    "Providing an incentive helps motivate children to save.",
    "Talk openly about money with your children",
    "Most kids love a challenge, so challenge them to see how much they can save in a month",
    "Make a habit of saving",
  ];

  static List<String> getSavingTips(){
    return savingTips;
  }
}

// Widget to scroll through savings tips
ticker() {
  return Stream.periodic(Duration(seconds: 10), (i) => i).map((i) => ParentSavingsTips.savingTips[i % ParentSavingsTips.savingTips.length]);
}

class ParentSavingsTipsBox extends StatefulWidget {
  @override
  _ParentSavingsTipsBoxState createState() => _ParentSavingsTipsBoxState();
}

class _ParentSavingsTipsBoxState extends State<ParentSavingsTipsBox> {
  late Stream<String> tipStream;

  @override
  void initState() {
    super.initState();
    tipStream = ticker();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.green.shade700,
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
        child: StreamBuilder<String>(
          stream: tipStream,
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? "Loading tips...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}