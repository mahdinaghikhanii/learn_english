import 'package:flutter/material.dart';
import 'package:learn_english/pages/home/home.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    'assets/onboarding.png',
                    width: 350,
                  ),
                ),
                Text(
                  "Train your brain and expand your vocabulary",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Journey into the realm of language, Boost Your Lexicon, Sharpen Your Mind.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    height: 60,
                    width: double.maxFinite,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange.shade200,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomePage()));
                      },
                      child: const Text("Get started",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.black)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
