import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(13),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: IconButton(
              padding: EdgeInsets.all(2),
              icon: Icon(CupertinoIcons.line_horizontal_3),
              onPressed: () {},
            )),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Text('Business Locator')),
        Container(
            margin: EdgeInsets.all(13),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: IconButton(
              padding: EdgeInsets.all(2),
              icon: Icon(CupertinoIcons.profile_circled),
              onPressed: () {},
            ))
      ],
    ));
  }
}
