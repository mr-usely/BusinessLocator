import 'package:flutter/material.dart';
import 'package:google_mao/components/search_button.dart';
import 'package:google_mao/components/search_input.dart';

class FormWidget extends StatelessWidget {
  FormWidget({super.key, required this.onSubmit, required this.textController});

  final TextEditingController textController;

  final Function onSubmit;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        SearchInput(
            controller: textController,
            label: "Search",
            width: size.width * 0.6),
        SearchButton(
            pressed: () => onSubmit(textController.text),
            text: "Search",
            width: size.width * 0.03)
      ],
    );
  }
}
