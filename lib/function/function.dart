import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mao/models/Businesses.dart';
import 'package:google_mao/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class Fun {
  static const isDevelopment = false;

  static const server = isDevelopment
      ? "http://10.0.2.2:3000"
      : "https://business-locator-api.onrender.com";

  static User? loggedUser;

  static List<Businesses> businessList = [];

  static List<Businesses> itemListBusinesses = [];

  static List<Businesses> itemFavorites = [];

  static List<Businesses> searchedItems = [];

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
    try {
      http.Response res =
          await http.get(Uri.parse('$server/business/nearby/$lat/$lng'));
      var data = json.decode(res.body);

      businessList.clear();

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
    } catch (_ClientSocketException) {
      if (kDebugMode) print("error");
    }
  }

// Get all barangays
  static isGetAllBrgys() async {
    try {
      http.Response res =
          await http.get(Uri.parse('$server/business/all/brgys'));
      var data = json.decode(res.body);

      barangayList.clear();

      for (var d in data) {
        barangayList.add(d["_id"]);
      }
    } catch (_ClientSocketException) {
      if (kDebugMode) print("error");
    }
  }

// load all businesses
  static loadAllBusinesses() async {
    try {
      http.Response res = await http.get(Uri.parse("$server/business"));
      var data = jsonDecode(res.body);

      itemListBusinesses.clear();
      for (var d in data) {
        itemListBusinesses.add(Businesses(
            id: d["_id"],
            name: d["name"],
            address: d["address"],
            barangay: d["barangay"],
            lat: d["location"]["coordinates"][1],
            lng: d["location"]["coordinates"][0],
            classification: d["classification"]));
      }
    } catch (_ClientSocketException) {
      if (kDebugMode) print("error");
    }
  }

  // load all favorites
  static loadAllFavorites(userId) async {
    try {
      http.Response res = await http.get(Uri.parse("$server/favorite/$userId"));
      var data = jsonDecode(res.body);

      itemFavorites.clear();

      for (var d in data) {
        itemFavorites.add(Businesses(
            id: d["_id"],
            name: d["name"],
            address: d["address"],
            barangay: d["barangay"],
            lat: d["location"]["coordinates"][1],
            lng: d["location"]["coordinates"][0],
            classification: d["classification"]));
      }
    } catch (_ClientSocketException) {
      if (kDebugMode) print("error");
    }
  }

  // add favorites
  static addFavorites(userId, businessId) async {
    var body = jsonEncode({"userId": userId, "businessId": businessId});
    var res = await http.post(Uri.parse("$server/favorite/add"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: body);
    var getData = jsonDecode(res.body);

    if (getData["type"] == "error") {
      return null;
    } else if (getData["type"] == "existing") {
      return "added";
    } else {
      return "added";
    }
  }

  // search Item
  static isSearchItem(item) async {
    http.Response res =
        await http.get(Uri.parse("$server/business/find/$item"));
    var data = jsonDecode(res.body);

    searchedItems.clear();

    for (var d in data) {
      searchedItems.add(Businesses(
          id: d["_id"],
          name: d["name"],
          address: d["address"],
          barangay: d["barangay"],
          lat: d["location"]["coordinates"][1],
          lng: d["location"]["coordinates"][0],
          classification: d["classification"]));
    }
  }

  // filter business by barangay
  static List<Businesses> filterBusinesses(barangay) {
    List<Businesses> businessList = [];
    List<Businesses> filteredBusiness =
        itemListBusinesses.where((e) => (e.barangay == barangay)).toList();

    businessList = filteredBusiness;

    return businessList;
  }

// update current address
  static updateAddress(userId, address) async {
    var body = jsonEncode({"address": address});
    var res = await http.patch(Uri.parse('$server/user/update/$userId'),
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json"
        },
        body: body);

    var data = json.decode(res.body);
    return data['type'];
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
