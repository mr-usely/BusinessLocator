import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mao/utils/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {super.key, required this.onTapMenu, required this.onTapProfileMenu});
  final Function onTapMenu;
  final Function onTapProfileMenu;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.93,
        margin: EdgeInsets.all(13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  padding: EdgeInsets.all(2),
                  icon: Icon(CupertinoIcons.line_horizontal_3),
                  color: primaryColor,
                  onPressed: () => onTapMenu(),
                )),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: const Text('MSMEs Business Locator')),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: IconButton(
                  padding: const EdgeInsets.all(2),
                  icon: const Icon(CupertinoIcons.profile_circled),
                  color: primaryColor,
                  onPressed: () => onTapProfileMenu(),
                ))
          ],
        ));
  }
}
