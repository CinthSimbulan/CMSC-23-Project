import 'package:cmsc_23_project/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../homepage.dart';
import 'signin.dart';

class Loadingpage extends StatefulWidget {
  static const routename = '/loading';
  const Loadingpage({super.key});

  @override
  State<Loadingpage> createState() => _Loadingpage();
}

class _Loadingpage extends State<Loadingpage> {
  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;

    return StreamBuilder(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error encountered! ${snapshot.error}"),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (!snapshot.hasData) {
            return const SignInPage();
          }

          // if user is logged in, display the scaffold containing the streambuilder for the todos
          return const Homepage();
        });
  }
}
