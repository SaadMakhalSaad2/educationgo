import 'package:educationgo/screens/HomePage.dart';
import 'package:educationgo/screens/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// FirebaseServices().signOut();
    final user = Provider.of<User?>(context);
    if (user != null) print('stream data: ${user.displayName}');

    if (user != null) {
      return HomePage();
    } else {
      return Login();
    }
  }
}
