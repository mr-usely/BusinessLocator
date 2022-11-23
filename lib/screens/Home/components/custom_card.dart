import 'package:flutter/material.dart';
import 'package:google_mao/screens/Home/components/form.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.widget,
    required this.onSearch,
    required this.textController,
  });

  final Widget widget;
  final Function onSearch;
  final TextEditingController textController;
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
        FormWidget(
            textController: textController,
            onSubmit: (searchItem) => onSearch(searchItem)),
        widget
      ]),
    );
  }
}
