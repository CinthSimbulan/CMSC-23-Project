import 'package:cmsc_23_project/pages/homepage.dart';
import 'package:cmsc_23_project/pages/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elbi Donation System',
      initialRoute: Homepage.routename,
      routes: {
        Homepage.routename: (context) => const Homepage(),
        Profile.routename: (context) => const Profile(),
      },
    );
  }
}
