import 'package:educationgo/MyFirebaseServices.dart';
import 'package:educationgo/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
            onPressed: () async {
              MyFirebaseServices().signInWithFacebook().then((value) {
                if (value.additionalUserInfo!.isNewUser) {
                  writeUser(value);
                }
              });
            },
            child: const Text('Login with FB'))
      ]),
    );
  }

  void writeUser(UserCredential? credentials) {
    User? user = credentials!.user;
    UserProfile profile = UserProfile(
        FirebaseAuth.instance.currentUser!.uid,
        user!.email.toString(),
        user.displayName.toString(),
        credentials.additionalUserInfo!.profile!['picture']['data']['url'],
        DateTime.now().millisecondsSinceEpoch.toString());

    var profileJson = profile.toJson();
    MyFirebaseServices().writeData(profileJson, 'users/${profile.id}');
  }
}
