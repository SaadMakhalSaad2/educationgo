import 'package:educationgo/models/user_profile.dart';
import 'package:flutter/material.dart';

class AppBarContent extends StatelessWidget {
  AsyncSnapshot snapshot;
  AppBarContent({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     UserProfile? profile = UserProfile(
      'id',
      'email',
      'user_name',
      'https://cdn2.psychologytoday.com/assets/styles/profile_teaser_micro/public/field_user_blogger_photo/7.jpg?itok=UDJ4N1sg',
      'dateJoined');
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      profile = snapshot.data;
      return Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(profile!.imageUrl.toString()),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text('Hi, ${profile?.name!.split(" ")[0].toString()}'),
        ],
      );
    }
  }
}
