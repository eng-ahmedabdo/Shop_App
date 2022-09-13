// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Screens/landing_page.dart';
import 'package:shop_app/Screens/main_screen.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapShot) {
          if (userSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapShot.connectionState == ConnectionState.active) {
            if (userSnapShot.hasData) {
              return MainScreen();
            } else {
              return LandingPage();
            }
          } else if (userSnapShot.hasError) {
            Center(
              child: Text('Error occurred'),
            );
          }
          return Text('Null');
        });
  }
}
