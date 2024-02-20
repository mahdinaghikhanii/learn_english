import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/pages/home/widgets/word.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _greeting = "";

  @override
  void initState() {
    super.initState();
    _updateGreeting();
  }

  void _updateGreeting() {
    DateTime now = DateTime.now();
    if (now.hour >= 5 && now.hour < 12) {
      setState(() {
        _greeting = "Good Morning!";
      });
    } else if (now.hour >= 12 && now.hour < 17) {
      setState(() {
        _greeting = "Good Afternoon!";
      });
    } else {
      setState(() {
        _greeting = "Good Evening!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.orange.shade200,
              child: Icon(CupertinoIcons.person),
            ),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _greeting,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    // color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "Let's learn something cool today",
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 16),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                "Practice English",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Text("You have new words!"),
            ),
            const WordOfTheDay(),
          ],
        ),
      ),
    );
  }
}
