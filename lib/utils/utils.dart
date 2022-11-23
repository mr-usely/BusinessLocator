import 'dart:convert';
import 'dart:math' as Math;

import 'package:dio/dio.dart';
import 'package:google_mao/models/UnitMeasure.dart';
import 'package:google_mao/utils/constants.dart';

//HaverSine formula
double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(deg2rad(lat1)) *
          Math.cos(deg2rad(lat2)) *
          Math.sin(dLon / 2) *
          Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c; // Distance in km
  return d;
}

double deg2rad(deg) {
  return deg * (Math.pi / 180);
}

// Get the estimated travel time and distance through google api
Future<UnitMeasure> getTravelTime(lat1, lon1, lat2, lon2) async {
  Dio dio = new Dio();
  UnitMeasure unit;
  Response response = await dio.get(
      "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$lat1,$lon1&destinations=$lat2, $lon2&key=$google_api_key");
  String dataDistance =
      response.data["rows"][0]["elements"][0]["distance"]["text"];
  String dataDuration =
      response.data["rows"][0]["elements"][0]["duration"]["text"];

  double a = double.parse(dataDistance.split(" ")[0]);
  double d = a * 1.60934;
  List t = dataDuration.split(" ");
  unit =
      UnitMeasure(time: t[0], timeUnit: t[1], distance: d.toStringAsFixed(1));
  return unit;
}

Future<dynamic> getCurrentlocationAddress(lat, lon) async {
  Dio dio = new Dio();
  UnitMeasure unit;
  Response response = await dio.get(
      "https://maps.google.com/maps/api/geocode/json?key=$google_api_key&language=en&latlng=$lat, $lon");

  return response.data["results"][0]["formatted_address"];
}
