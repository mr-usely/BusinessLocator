import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mao/utils/constants.dart';
import 'package:google_mao/models/Businesses.dart';
import 'package:google_mao/screens/Home/components/item_cards.dart';

class Menu extends StatelessWidget {
  const Menu(
      {super.key,
      required this.itemList,
      required this.onPressed,
      required this.resize,
      required this.onResized});
  final List<Businesses> itemList;
  final Function onPressed;
  final Function onResized;
  final bool resize;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
        height: resize ? size.height * 0.06 : size.height * 0.35,
        width: size.width * 0.93,
        duration: const Duration(milliseconds: 500),
        margin: EdgeInsets.symmetric(horizontal: 13),
        padding: resize ? EdgeInsets.zero : EdgeInsets.only(left: 13),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15)),
        child: resize
            ? IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => onResized(),
                icon: Icon(
                  CupertinoIcons.chevron_compact_up,
                  size: 50,
                  color: primaryColor,
                ))
            : Stack(
                children: <Widget>[
                  Positioned(
                    left: size.width * 0.37,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => onResized(),
                        icon: Icon(
                          CupertinoIcons.chevron_compact_down,
                          size: 50,
                          color: primaryColor,
                        )),
                  ),
                  Positioned(
                    top: 45,
                    child: Text('Nearest Businesses',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                  Positioned(
                    top: 75,
                    child: Container(
                      height: 170,
                      width: size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: itemList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ItemCards(
                                business: itemList[index],
                                onPressed: onPressed);
                          }),
                    ),
                  ),
                ],
              ));
  }
}
