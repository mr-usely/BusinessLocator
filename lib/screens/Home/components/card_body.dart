import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mao/models/Businesses.dart';

class CardBody extends StatelessWidget {
  const CardBody({super.key, required this.itemList});
  final List<Businesses> itemList;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.93,
      height: size.height * 0.45,
      margin: EdgeInsets.all(13),
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'List of Businesses',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Container(
          height: size.height * 0.39,
          child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(13),
                  child: Text('${itemList[index].name}'),
                );
              }),
        )
      ]),
    );
  }
}
