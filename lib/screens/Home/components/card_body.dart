import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardBody extends StatelessWidget {
  const CardBody(
      {super.key,
      required this.title,
      required this.widget,
      required this.onPressedBack});
  final String title;
  final Widget widget;
  final Function onPressedBack;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.93,
      height: size.height * 0.48,
      margin: const EdgeInsets.all(13),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (title != "Barangays" && title != "Favorites")
                ? IconButton(
                    onPressed: () => onPressedBack(),
                    icon: Icon(CupertinoIcons.arrow_left))
                : SizedBox(width: 50),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 50,
            )
          ],
        ),
        widget
      ]),
    );
  }
}
