import 'package:flutter/material.dart';
import 'package:google_mao/utils/constants.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.content, required this.height});
  final Widget content;
  final double height;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(13),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
      height: size.height * height,
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: kTextGreyColor, borderRadius: BorderRadius.circular(15)),
      child: content,
    );
  }
}
