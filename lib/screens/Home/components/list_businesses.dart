import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_mao/models/Businesses.dart';
import 'package:google_mao/utils/constants.dart';

class ListBusinesses extends StatelessWidget {
  const ListBusinesses(
      {super.key,
      required this.onPressed,
      required this.business,
      required this.favoriteIcon,
      required this.onSlideRight,
      required this.onSlideLeft});
  final Function onPressed;
  final Businesses business;
  final bool favoriteIcon;
  final Function onSlideRight;
  final Function onSlideLeft;
  static bool showIcon = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () =>
              onPressed(business.id, business.name, business.lat, business.lng),
          onPanUpdate: (details) {
            if (details.delta.dx > 0)
              onSlideLeft();
            else
              onSlideRight();
          },
          child: AnimatedContainer(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(13),
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
                color: kTextGreyColor, borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Icon(
                  favoriteIcon
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.briefcase,
                  color: primaryColor,
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('${business.name}',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ),
        favoriteIcon
            ? Positioned(
                top: 20,
                right: 15,
                child: business.isOnDelete
                    ? Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          CupertinoIcons.trash,
                          color: Colors.white,
                          size: 17,
                        ))
                    : SizedBox())
            : SizedBox()
      ],
    );
  }
}
