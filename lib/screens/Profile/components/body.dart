import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mao/function/function.dart';
import 'package:google_mao/utils/constants.dart';
import 'package:google_mao/utils/utils.dart';
import 'package:location/location.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String address = "";
  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      getCurrentlocationAddress(location.latitude, location.longitude)
          .then((value) {
        setState(() {
          address = value.toString();
          Fun.loggedUser!.address = value.toString();

          var result = Fun.updateAddress(Fun.loggedUser!.id, address);

          if (kDebugMode) print(result);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 13),
            child: Text('Profile',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w800)),
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                          color: kTextGreyColor,
                          border: Border.all(
                              color: primaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                              strokeAlign: StrokeAlign.outside),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Icon(
                                CupertinoIcons.profile_circled,
                                size: 50,
                                color: primaryColor,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    '${Fun.loggedUser!.firstName} ${Fun.loggedUser!.lastName}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    "${Fun.loggedUser!.birthDay!.split('T')[0]}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${Fun.loggedUser!.email}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ))
                                ],
                              ),
                            )
                          ]))),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                          color: kTextGreyColor,
                          border: Border.all(
                              color: primaryColor,
                              width: 1,
                              style: BorderStyle.solid,
                              strokeAlign: StrokeAlign.outside),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: <Widget>[
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Account ID: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Text('${Fun.loggedUser!.id}',
                                    style: TextStyle(fontSize: 14))
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('First Name: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Text('${Fun.loggedUser!.firstName}',
                                    style: TextStyle(fontSize: 14))
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Last Name: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Text('${Fun.loggedUser!.lastName}',
                                    style: TextStyle(fontSize: 14))
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Birthday: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Text(
                                    "${Fun.loggedUser!.birthDay!.split("T")[0]}",
                                    style: TextStyle(fontSize: 14))
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Address: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                                Fun.loggedUser!.address == null
                                    ? GestureDetector(
                                        onTap: () => getCurrentLocation(),
                                        child: Text(
                                            'Current location as address',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: primaryColor)),
                                      )
                                    : Text("${Fun.loggedUser!.address}",
                                        style: TextStyle(fontSize: 13))
                              ]),
                        ],
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
