import 'package:flutter/cupertino.dart';

class Menus {
  String name;
  IconData icon;
  Menus({required this.name, required this.icon});
}

List<Menus> menus = [
  Menus(name: 'Search', icon: CupertinoIcons.search),
  Menus(name: 'Barangays', icon: CupertinoIcons.placemark),
  Menus(name: 'Favorites', icon: CupertinoIcons.heart),
];
