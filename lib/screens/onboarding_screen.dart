import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Welcome to To_Do',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 20),
          Image.asset('assets/images/todoimage.png'),
          const SizedBox(height: 35),
          const Text(
            'Reminders made simple',
            style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
            child: Text(
                'Welcome to the todo_list app where you can organize your long work schedules and never forget a task'),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: (() {
              onDone(context);
            }),
            child: const Text('Get Started'),
            style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                onSurface: kPrimaryLightColor,
                elevation: 5.0,
                minimumSize: const Size(200, 50)),
          )
        ],
      ),
    );
  }

  void onDone(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
