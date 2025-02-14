import 'package:flutter/material.dart';

class ChildSavingsTips{

  static final List<String> savingTips = [
    "Having your own pot of money gives you a sense of freedom.",
    "Set realistic goals that can be achieved.",
    "Think twice before spending. Think 'Do I really need this?'",
    "Help around the house to earn money at home.",
    "Make a habit of saving.",
    "Resist peer pressure!",
  ];

  static List<String> getSavingTips(){
    return savingTips;
  }
}

// Widget to scroll through savings tips
ticker() {
  return Stream.periodic(Duration(seconds: 10), (i) => i).map((i) => ChildSavingsTips.savingTips[i % ChildSavingsTips.savingTips.length]);
}

class ChildSavingsTipsBox extends StatefulWidget {
  @override
  _ChildSavingsTipsBoxState createState() => _ChildSavingsTipsBoxState();
}

class _ChildSavingsTipsBoxState extends State<ChildSavingsTipsBox> {
  late Stream<String> tipStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream with the first tip immediately
    tipStream = _getTipsStream();
  }

  Stream<String> _getTipsStream() async* {
    // Yield the first tip immediately
    yield ChildSavingsTips.savingTips[0];

    // Then yield the rest periodically. allows us to continue yielding values from the ticker()
    yield* ticker();
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