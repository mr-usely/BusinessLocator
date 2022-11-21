import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mao/utils/constants.dart';

class DashboardDetail extends StatelessWidget {
  const DashboardDetail(
      {super.key,
      required this.distance,
      required this.time,
      required this.timeUnit});
  final double distance;
  final int time;
  final String timeUnit;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.93,
      margin: EdgeInsets.symmetric(horizontal: 13),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Estimated Time', style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('$time',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700)),
                      Text(' $timeUnit', style: TextStyle(fontSize: 18)),
                    ],
                  )
                ],
              ),
            ),
            Container(
                height: 58,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.circle_fill,
                          color: primaryColor,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '- - -',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                        Icon(
                          CupertinoIcons.placemark,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Estimated Distance', style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('$distance',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700)),
                      Text(' kms', style: TextStyle(fontSize: 18)),
                    ],
                  )
                ],
              ),
            )
          ]),
    );
  }
}
