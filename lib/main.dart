import 'package:flutter/material.dart';
import 'package:todo_list/screens/home_screen.dart';
import 'package:todo_list/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool show = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  show = prefs.getBool('ON_BOARDING') ?? true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do',
      //home: const OnboardingScreen(),
      home: show ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
