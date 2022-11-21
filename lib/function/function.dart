import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mao/models/Businesses.dart';
import 'package:google_mao/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class Fun {
  static const server = "http://10.0.2.2:3000";

  static User? loggedUser;

  static List<Businesses> businessList = [];

  static List barangayList = [];

  static LocationData? currentLoc;

  // create account
  static isCreateAccount(firstName, lastName, birthDay, email, password) async {
    final data = jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "birthDay": birthDay,
      "email": email,
      "password": password
    });
    var res = await http.post(Uri.parse('$server/user/create'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: data);
    var dataType = json.decode(res.body);

    if (dataType["type"] == "existing") {
      return "existing";
    } else {
      return User.fromJson(jsonDecode(res.body));
    }
  }

  // login user
  static isUserLogin(email, password) async {
    final data = jsonEncode({"email": email, "password": password});
    var res = await http.post(Uri.parse('$server/user/login'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: data);
    var dataType = json.decode(res.body);

    if (dataType["type"] == "error") {
      return "existing";
    } else {
      return User.fromJson(jsonDecode(res.body));
    }
  }

  // Get all nearby businesses
  static isGetNearbyBusinesses(lat, lng) async {
    businessList.clear();
    http.Response res =
        await http.get(Uri.parse('$server/business/nearby/$lat/$lng'));
    var data = json.decode(res.body);

    for (var d in data) {
      businessList.add(Businesses(
          id: d["_id"],
          name: d["name"],
          address: d["address"],
          barangay: d["barangay"],
          lat: d["location"]["coordinates"][1],
          lng: d["location"]["coordinates"][0],
          classification: d["classification"]));
    }
  }

  static isGetAllBrgys() async {
    http.Response res = await http.get(Uri.parse('$server/business/all/brgys'));
    var data = json.decode(res.body);

    for (var d in data) {
      barangayList.add(d["_id"]);
    }

    print(barangayList[0]);
  }

  // Global dialog
  static openDialog(
      BuildContext context, IconData iconName, String message, Color color) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: AlertDialog(
                elevation: 0.0,
                insetPadding: EdgeInsets.symmetric(horizontal: 50),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                content: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Positioned(
                          top: 350,
                          child: Icon(
                            iconName,
                            size: 55,
                            color: color,
                          ))
                    ]),
              ),
              onWillPop: null);
        });
  }
}
