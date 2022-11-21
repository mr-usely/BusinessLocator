import 'package:flutter/material.dart';
import 'package:google_mao/utils/constants.dart';

class InputsWidget extends StatelessWidget {
  const InputsWidget(
      {super.key,
      required this.controller,
      required this.label,
      required this.obscure,
      required this.width});
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: width,
      child: Column(
        children: [
          TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                  labelText: label,
                  floatingLabelStyle: TextStyle(color: primaryColor),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: primaryColor,
                          width: 2,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding: const EdgeInsets.all(10.0))),
        ],
      ),
    );
  }
}
