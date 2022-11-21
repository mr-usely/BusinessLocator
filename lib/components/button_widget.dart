import 'package:flutter/material.dart';
import 'package:google_mao/utils/constants.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.pressed,
      required this.text,
      required this.width});

  final Function pressed;
  final String text;
  final double width;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => pressed(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: width, vertical: 12)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      child: Text("$text",
          style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600)),
    );
  }
}
