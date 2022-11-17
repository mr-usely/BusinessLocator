import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mao/constants.dart';
import 'package:google_mao/models/Businesses.dart';
import 'package:google_mao/screens/Home/components/item_cards.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, required this.itemList, required this.onPressed});
  final List<Businesses> itemList;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.35,
        width: size.width * 0.93,
        margin: EdgeInsets.symmetric(horizontal: 13),
        padding: EdgeInsets.only(left: 13, top: 20, bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nearest Businesses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 180,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemCards(
                        business: itemList[index], onPressed: onPressed);
                  }),
            )
          ],
        ));
  }
}
