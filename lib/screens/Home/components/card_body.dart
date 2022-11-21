import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mao/models/Businesses.dart';
import 'package:google_mao/screens/Home/components/list_businesses.dart';
import 'package:google_mao/utils/constants.dart';

class CardBody extends StatelessWidget {
  const CardBody(
      {super.key,
      required this.itemList,
      required this.onPressed,
      required this.title,
      required this.favoriteIcon});
  final List<Businesses> itemList;
  final Function onPressed;
  final String title;
  final bool favoriteIcon;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.93,
      height: size.height * 0.48,
      margin: EdgeInsets.all(13),
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Container(
          height: size.height * 0.39,
          margin: EdgeInsets.only(top: 10),
          child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListBusinesses(
                    favoriteIcon: favoriteIcon,
                    business: itemList[index],
                    onPressed: onPressed,
                    onSlideRight: () => itemList[index].isOnDelete = true,
                    onSlideLeft: (d) {
                      itemList[index].isOnDelete = false;
                      print(d);
                    });
              }),
        )
      ]),
    );
  }
}
