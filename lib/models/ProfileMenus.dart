import 'package:flutter/cupertino.dart';

class ProfileMenus {
  String name;
  IconData icon;
  ProfileMenus({required this.name, required this.icon});
}

List<ProfileMenus> profileMenus = [
  ProfileMenus(name: 'Profile', icon: CupertinoIcons.person),
  ProfileMenus(name: 'Logout', icon: CupertinoIcons.square_arrow_left),
];
