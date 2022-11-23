import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mao/utils/constants.dart';

class ItemBarangays extends StatelessWidget {
  const ItemBarangays(
      {super.key, required this.barangays, required this.pressed});
  final String barangays;
  final Function pressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pressed(barangays),
      child: Container(
        decoration: BoxDecoration(
            color: kTextGreyColor, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      height: 100,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            CupertinoIcons.placemark,
                            size: 35,
                            color: Colors.white,
                          ),
                          Text('$barangays',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(child: Text('Tap to view list of businesses')),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(right: 8.0),
                alignment: Alignment.bottomRight,
                child: Icon(CupertinoIcons.arrow_right))
          ],
        ),
      ),
    );
  }
}
