import 'package:flutter/material.dart';
import 'package:google_mao/models/menus.dart';
import 'package:google_mao/utils/constants.dart';

class MenuContainer extends StatelessWidget {
  const MenuContainer(
      {super.key, required this.onPressed, required this.menusList});
  final Function onPressed;
  final List<Menus> menusList;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.348,
      height: 85,
      margin: EdgeInsets.all(13),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(menusList.length, (int i) {
          return GestureDetector(
            onTap: () => onPressed(menusList[i].name),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    menusList[i].icon,
                    size: 16,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('${menusList[i].name}'),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
