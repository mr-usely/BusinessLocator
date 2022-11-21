import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mao/utils/constants.dart';
import 'package:google_mao/models/Businesses.dart';

class ItemCards extends StatelessWidget {
  const ItemCards({super.key, required this.business, required this.onPressed});
  final Businesses business;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed(business.id, business.name, business.lat, business.lng);
        },
        child: Container(
          width: 115,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: business.isSelected
                  ? Border.all(
                      width: 2,
                      style: BorderStyle.solid,
                      color: primaryColor,
                      strokeAlign: StrokeAlign.outside)
                  : null,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                      height: 85,
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.4),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Center(
                          child: Icon(
                        CupertinoIcons.bag,
                        size: 50,
                        color: Colors.white,
                      )))),
              Positioned(
                bottom: 3,
                child: Container(
                  height: 65,
                  width: 130,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          child: Text("${business.name}",
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
