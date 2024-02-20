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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: "Account",
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.orange.shade200,
              child: const Icon(CupertinoIcons.person),
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
            const SizedBox(height: 25),
            Row(children: [
              const Text(
                "Your lesson",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: Colors.orange.shade200)),
              )
            ]),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: MediaQuery.sizeOf(context).width,
              height: 180,
              child: ListView.builder(
                  padding: const EdgeInsets.only(left: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 25),
                      height: 150,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20)),
                              width: 150,
                              height: 100,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    index == 0
                                        ? "assets/flag.png"
                                        : "assets/british_flag.png",
                                    width: 90,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 105,
                                  child: LinearProgressIndicator(
                                    value: 0.48,
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.orange.shade200,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "50%",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  index == 0 ? "Speaking 101" : "New words",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  index == 0 ? "30 days * daily" : "New words",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )),
                          ]),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
