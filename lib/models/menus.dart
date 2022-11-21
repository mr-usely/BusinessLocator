import 'package:flutter/cupertino.dart';

class Menus {
  String name;
  IconData icon;
  Menus({required this.name, required this.icon});
}

List<Menus> menus = [
  Menus(name: 'Businesses', icon: CupertinoIcons.briefcase),
  Menus(name: 'Favorites', icon: CupertinoIcons.heart),
];
